require 'shellwords'
require 'yaml'

def run_autoclop
  os = File.read('/etc/issue')
  autoclop(os, ENV)
end

def autoclop(os, env)
  warning, cfg = ConfigFactory.build(env)
  Kernel.puts warning
  unless Kernel.system clop_command(cfg.python_version(os), cfg.opt, cfg.libargs)
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

def clop_command(python_version, optimization, libargs)
  "clop configure --python #{esc python_version} -#{esc optimization} #{libargs.map { |a| esc a }.join(' ')}"
end

class ConfigFactory
  def self.build(env)
    path = env['AUTOCLOP_CONFIG']
    user = env['USER']
    if path.nil? || path.empty?
      [ "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration.",
        DefaultConfig.new(user) ]
    elsif (c = from_yaml(path, user)).invalid?
      [ "WARNING: Invalid YAML in #{path}. Assuming the default configuration.",
        DefaultConfig.new(user) ]
    else
      ['', c]
    end
  end

  def self.from_yaml(path, user)
    Config.new YAML.safe_load(File.read(path)), user
  end
end

class Config < Struct.new(:cfg, :user)
  class RepeatedFlag < Struct.new(:flag, :list)
    def to_a
      list.map { |l| flag + l }
    end
  end

  def libargs
    args = case
      when libs
        ['-l', libs]
      when libdir
        ['-L', [libdir]]
      when libdirs
        ['-L', libdirs]
      else
        ['-L', ["/home/#{user}/.cbiscuit/lib"]]
      end
    RepeatedFlag.new(*args).to_a
  end

  def invalid?
    cfg.nil?
  end

  def python_version(os)
    cfg['python-version'] ||
      DefaultConfig.new(nil).python_version(os)
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

class DefaultConfig < Struct.new(:user)
  def python_version(os)
    # Red Hat has deprecated Python 2
    os =~ /Red Hat 8/ ? 3 : 2
  end

  def opt
    'O2'
  end

  def libargs
    ["-L/home/#{user}/.cbiscuit/lib"]
  end
end

def esc arg
  Shellwords.escape arg
end
