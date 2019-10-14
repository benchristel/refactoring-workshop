require 'shellwords'
require 'yaml'                                # TODO: no blank line after requires
def run_autoclop                              # TODO: several methods with similar names; TODO: global methods
  $config = ENV['AUTOCLOP_CONFIG']            # TODO: global variables $config and ENV
  $os = File.read('/etc/issue')               # TODO: global variable $os
  autoclop                                    # TODO: multiple responsibilities (get inputs + invoke procedure)
end

def autoclop
  return invoke_clop_default if $config.nil? || $config.empty? # TODO: early return; TODO: anonymous boolean logic; TODO: nil check; TODO: order-dependence (we have to check nil? before empty?)
  python_version = 2
  # Red Hat has deprecated Python 2
  python_version = 3 if $os =~ /Red Hat 8/    # TODO: python_version reassigned; TODO: magic regex
  cfg = YAML.safe_load(File.read($config))    # TODO: coupling to both format (yaml) and data source (file); TODO: variable name cfg
  return invoke_clop_default :invalid_yaml if cfg.nil? # TODO: early return; TODO: nil check
  python_version = cfg['python-version'] if cfg['python-version'] # TODO: reassigned python_version again
  optimization = cfg['opt'] if cfg['opt']     # TODO: dead code (conditional can be removed)

  if cfg['libs']                              # TODO: coupling to the structure of the cfg hash
    libargs = ''                              # TODO: libargs gets mutated
    index = 0                                 # TODO: index variable defined outside of loop
    for lib in cfg['libs']                    # TODO: cyclomatic complexity; nested loops and conditionals
      libargs << "-l#{esc lib}"
      if index < cfg['libs'].length - 1
        libargs << ' '
      end
      index += 1
    end
  elsif cfg['libdir']
    libargs = "-L#{esc cfg['libdir']}"        # TODO: near-duplication of this line (see line 35)
  elsif cfg['libdirs']
    libargs = ''                              # TODO: near-duplication of this block (see line 19)
    index = 0
    for libdir in cfg['libdirs']
      libargs << "-L#{esc libdir}"
      if index < cfg['libdirs'].length - 1
        libargs << ' '
      end
      index += 1
    end
  end
  libargs ||= "-L/home/#{esc ENV['USER']}/.cbiscuit/lib" # TODO: asymmetry; this is a conditional that doesn't follow the if-elsif flow

  invoke_clop(python_version, optimization || 'O2', libargs || '') # TODO: default value of libargs is never used?
end

def invoke_clop_default(message_type=nil)
  py = 2
  py = 3 if $os =~ /Red Hat 8/ # bugfix       # TODO: duplicated logic (see line 13)
  if message_type == :invalid_yaml            # TODO: multiple responsibilities (print message, use defaults)
    Kernel.puts "WARNING: Invalid YAML in #{$config}. Assuming the default configuration."
  else
    Kernel.puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration." # TODO: coupling to the AUTOCLOP_CONFIG env var name
  end
  invoke_clop(py, 'O2', "-L/home/#{esc ENV['USER']}/.cbiscuit/lib") # TODO: deep call stack, but no real abstraction
end

def invoke_clop(python_version, optimization = 'O1', libargs = '') # TODO: default arguments aren't used?
  libargs = ' ' + libargs unless libargs.empty? # TODO: unclear why this line exists
  ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization}#{libargs}" # TODO: asymmetry: no esc call on libargs
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

def esc arg # TODO: middleman
  Shellwords.escape arg
end
