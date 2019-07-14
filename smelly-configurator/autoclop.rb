require 'shellwords'
require 'yaml'
def run_autoclop
  config = ENV['AUTOCLOP_CONFIG']
  os = File.read('/etc/issue')
  autoclop(os, config)
end

def autoclop(os, config)
  cmd = ClopCommand.new(os, config)
  Kernel.puts cmd.warning
  ok = Kernel.system cmd.to_s
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

class ClopCommand < Struct.new(:os, :config)
  def warning
    if config.nil? || config.empty?
      "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
    elsif cfg.nil?
      "WARNING: Invalid YAML in #{config}. Assuming the default configuration."
    end
  end

  def to_s
    if config.nil? || config.empty? || cfg.nil?
      default_command
    else
      libargs =
        if cfg['libs']
          cfg['libs'].map { |l| "-l#{esc l}" }.join(' ')
        elsif cfg['libdir']
          "-L#{esc cfg['libdir']}"
        elsif cfg['libdirs']
          cfg['libdirs'].map { |l| "-L#{esc l}" }.join(' ')
        else
          "-L/home/#{ENV['USER']}/.cbiscuit/lib"
        end

      clop_command(python_version(os, cfg), cfg['opt'] || 'O2', libargs)
    end
  end

  private

  def default_command
    clop_command(python_version(os, {}), 'O2', "-L/home/#{ENV['USER']}/.cbiscuit/lib")
  end

  def clop_command(python_version, optimization, libargs)
    "clop configure --python #{esc python_version} -#{esc optimization} #{libargs}"
  end

  def python_version(os, config)
    config['python-version'] || (
      # Red Hat has deprecated Python 2
      os =~ /Red Hat 8/ ? 3 : 2
    )
  end

  def cfg
    YAML.safe_load(File.read(config))
  end

  def esc arg
    Shellwords.escape arg
  end
end
