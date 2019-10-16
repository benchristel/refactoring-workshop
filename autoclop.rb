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
    if config.nil? || config.empty?
      Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
      py = 2
      py = 3 if @os =~ /Red Hat 8/ # bugfix
      invoke_clop(py, 'O2', "-L/home/#{esc @env['USER']}/.cbiscuit/lib")
    elsif cfg.nil?
      Kernel.puts "WARNING: Invalid YAML in #{config}. Assuming the default configuration."
      py = 2
      py = 3 if @os =~ /Red Hat 8/ # bugfix
      invoke_clop(py, 'O2', "-L/home/#{esc @env['USER']}/.cbiscuit/lib")
    else
      python_version = 2
      # Red Hat has deprecated Python 2
      python_version = 3 if @os =~ /Red Hat 8/
      python_version = cfg['python-version'] if cfg['python-version']
      optimization = cfg['opt'] if cfg['opt']

      if cfg['libs']
        libargs = ''
        index = 0
        for lib in cfg['libs']
          libargs << "-l#{esc lib}"
          if index < cfg['libs'].length - 1
            libargs << ' '
          end
          index += 1
        end
      elsif cfg['libdir']
        libargs = "-L#{esc cfg['libdir']}"
      elsif cfg['libdirs']
        libargs = ''
        index = 0
        for libdir in cfg['libdirs']
          libargs << "-L#{esc libdir}"
          if index < cfg['libdirs'].length - 1
            libargs << ' '
          end
          index += 1
        end
      end
      libargs ||= "-L/home/#{esc @env['USER']}/.cbiscuit/lib"

      invoke_clop(python_version, optimization || 'O2', libargs || '')
    end
  end

  def invoke_clop(python_version, optimization = 'O1', libargs = '')
    libargs = ' ' + libargs unless libargs.empty?
    ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization}#{libargs}"
    if !ok
      raise "clop failed. Please inspect the output above to determine what went wrong."
    end
  end

  def cfg
    YAML.safe_load(File.read(config))
  end

  def esc arg
    Shellwords.escape arg
  end

  private

  def config
    @env['AUTOCLOP_CONFIG']
  end
end
