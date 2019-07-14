require 'shellwords'
require 'yaml'
def run_autoclop
  $config = ENV['AUTOCLOP_CONFIG']
  $os = File.read('/etc/issue')
  autoclop
end

def autoclop
  return invoke_clop_default if $config.nil? || $config.empty?
  cfg = YAML.safe_load(File.read($config))
  return invoke_clop_default :invalid_yaml if cfg.nil?
  python_version = python_version($os, cfg)
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
  libargs ||= "-L/home/#{ENV['USER']}/.cbiscuit/lib"

  invoke_clop(python_version, optimization || 'O2', libargs || '')
end

def invoke_clop_default(message_type=nil)
  py = python_version($os, {})
  if message_type == :invalid_yaml
    Kernel.puts "WARNING: Invalid YAML in #{$config}. Assuming the default configuration."
  else
    Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
  end
  invoke_clop(py, 'O2', "-L/home/#{ENV['USER']}/.cbiscuit/lib")
end

def invoke_clop(python_version, optimization, libargs)
  ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization} #{libargs}"
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

def python_version(os, config)
  config['python-version'] || (
    # Red Hat has deprecated Python 2
    os =~ /Red Hat 8/ ? 3 : 2
  )
end

def esc arg
  Shellwords.escape arg
end
