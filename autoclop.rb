require 'shellwords'
require 'yaml'

def run_autoclop
  os = File.read('/etc/issue')
  Autoclop.new(os, ENV).autoclop
end

class Autoclop
  def initialize(os, env)
    @os = os
    @env = env
  end

  class Config < Struct.new(:warnings, :clop_args)
  end

  def autoclop
    config =
      if config_path.to_s.empty?
        Config.new(
          ["WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."],
          [default_python_version, 'O2', "-L/home/#{esc @env['USER']}/.cbiscuit/lib"]
        )
      elsif cfg.nil?
        Config.new(
          ["WARNING: Invalid YAML in #{config_path}. Assuming the default configuration."],
          [default_python_version, 'O2', "-L/home/#{esc @env['USER']}/.cbiscuit/lib"]
        )
      else
        python_version = cfg['python-version'] || default_python_version
        optimization = cfg['opt'] || 'O2'

        flag, libargs =
          if cfg['libs']
            ["-l", cfg['libs']]
          elsif cfg['libdir']
            ["-L", [cfg['libdir']]]
          elsif cfg['libdirs']
            ["-L", cfg['libdirs']]
          else
            ["-L", ["/home/#{@env['USER']}/.cbiscuit/lib"]]
          end

        Config.new(
          [],
          [python_version, optimization, libargs.map { |arg| "#{flag}#{esc arg}" }.join(' ')]
        )
      end

    config.warnings.each { |warning| Kernel.puts warning }
    python_version, optimization, libargs = config.clop_args
    libargs = ' ' + libargs unless libargs.empty?
    ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization}#{libargs}"
    if !ok
      raise "clop failed. Please inspect the output above to determine what went wrong."
    end
  end

  def cfg
    YAML.safe_load(File.read(config_path))
  end

  def esc arg
    Shellwords.escape arg
  end

  private

  def default_python_version
    @os =~ /Red Hat 8/ ? 3 : 2 # Red Hat has deprecated Python 2
  end

  def config_path
    @env['AUTOCLOP_CONFIG']
  end
end
