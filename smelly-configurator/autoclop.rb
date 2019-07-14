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

  invoke_clop(python_version, cfg['opt'] || 'O2', libargs || '')
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
