require 'shellwords'
require 'yaml'
def run_autoclop
  config_path = ENV['AUTOCLOP_CONFIG']
  os = File.read('/etc/issue')
  autoclop(os, config_path, ENV['USER'])
end

def autoclop(os, config_path, user)
  cmd =
    if config_path.nil? || config_path.empty?
      Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
      clop_command(python_version(os, {}), 'O2', "-L/home/#{user}/.cbiscuit/lib")
    else
      cfg = YAML.safe_load(File.read(config_path))

      if cfg.nil?
        Kernel.puts "WARNING: Invalid YAML in #{config_path}. Assuming the default configuration."
        clop_command(python_version(os, {}), 'O2', "-L/home/#{user}/.cbiscuit/lib")
      else
        libargs =
          if cfg['libs']
            cfg['libs'].map { |l| "-l#{esc l}" }.join(' ')
          elsif cfg['libdir']
            "-L#{esc cfg['libdir']}"
          elsif cfg['libdirs']
            cfg['libdirs'].map { |l| "-L#{esc l}" }.join(' ')
          else
            "-L/home/#{user}/.cbiscuit/lib"
          end

        clop_command(python_version(os, cfg), cfg['opt'] || 'O2', libargs)
      end
    end

  ok = Kernel.system cmd
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
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

def esc arg
  Shellwords.escape arg
end
