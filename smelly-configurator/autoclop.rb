require 'shellwords'
require 'yaml'
def run_autoclop
  $config = ENV['AUTOCLOP_CONFIG']
  $os = File.read('/etc/issue')
  autoclop
end

def autoclop
  if $config.nil? || $config.empty?
    Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
    return invoke_clop_default
  end

  cfg = YAML.safe_load(File.read($config))

  if cfg.nil?
    Kernel.puts "WARNING: Invalid YAML in #{$config}. Assuming the default configuration."
    return invoke_clop_default
  end

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

  invoke_clop(python_version($os, cfg), cfg['opt'] || 'O2', libargs)
end

def invoke_clop_default
  invoke_clop(python_version($os, {}), 'O2', "-L/home/#{ENV['USER']}/.cbiscuit/lib")
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
