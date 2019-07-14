require 'shellwords'
require 'yaml'
def run_autoclop
  config_path = ENV['AUTOCLOP_CONFIG']
  os = File.read('/etc/issue')
  autoclop(os, config_path, ENV['USER'])
end

class Config < Struct.new(:cfg, :user)
  def self.load(path, user)
    new YAML.safe_load(File.read(path)), user
  end

  def libargs
    if libs
      libs.map { |l| "-l#{l}" }
    elsif libdir
      ["-L#{libdir}"]
    elsif libdirs
      libdirs.map { |l| "-L#{l}" }
    else
      ["-L/home/#{user}/.cbiscuit/lib"]
    end
  end

  def invalid?
    cfg.nil?
  end

  def python_version(os)
    cfg['python-version'] || (
      # Red Hat has deprecated Python 2
      os =~ /Red Hat 8/ ? 3 : 2
    )
  end

  def opt
    cfg['opt'] || 'O2'
  end

  private

  def libdir
    cfg['libdir']
  end

  def libdirs
    cfg['libdirs']
  end

  def libs
    cfg['libs']
  end
end

class NullConfig < Struct.new(:user)
  def python_version(os)
    os =~ /Red Hat 8/ ? 3 : 2
  end

  def opt
    'O2'
  end

  def libargs
    ["-L/home/#{user}/.cbiscuit/lib"]
  end
end

def autoclop(os, config_path, user)
  cfg =
    if config_path.nil? || config_path.empty?
      Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
      NullConfig.new(user)
    elsif Config.load(config_path, user).invalid?
      Kernel.puts "WARNING: Invalid YAML in #{config_path}. Assuming the default configuration."
      NullConfig.new(user)
    else
      Config.load(config_path, user)
    end

  cmd = clop_command(cfg.python_version(os), cfg.opt, cfg.libargs)
  ok = Kernel.system cmd
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

def clop_command(python_version, optimization, libargs)
  "clop configure --python #{esc python_version} -#{esc optimization} #{libargs.map { |a| esc a }.join(' ')}"
end

def esc arg
  Shellwords.escape arg
end
