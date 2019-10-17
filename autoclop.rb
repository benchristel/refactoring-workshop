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

  def autoclop
    python_version = default_python_version
    optimization = 'O2'
    library_flag = "-L"
    library_args = ["/home/#{@env['USER']}/.cbiscuit/lib"]

    if config_path.to_s.empty?
      warnings = ["WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."]
    elsif cfg.nil?
      warnings = ["WARNING: Invalid YAML in #{config_path}. Assuming the default configuration."]
    else
      warnings = []
      python_version = cfg['python-version'] || default_python_version
      optimization = cfg['opt'] || 'O2'

      if cfg['libs']
        library_flag = "-l"
        library_args = cfg['libs']
      elsif cfg['libdir']
        library_flag = "-L"
        library_args = [cfg['libdir']]
      elsif cfg['libdirs']
        library_flag = "-L"
        library_args = cfg['libdirs']
      end
    end

    warnings.each { |warning| Kernel.puts warning }
    ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization} #{library_args.map { |a| esc "#{library_flag}#{a}" }.join(' ')}".strip
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
