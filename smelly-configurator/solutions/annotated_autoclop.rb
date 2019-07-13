require 'shellwords'
require 'yaml'
# SMELL: no space after requires makes it hard to see units of code
# SMELL: similarly-named methods doing slightly different things
def run_autoclop
  # SMELL: global variables can be replaced by parameters
  # SMELL: primitive obsession: config is passed around as a filename
  $config = ENV['AUTOCLOP_CONFIG']
  # SMELL: system call that can't be stubbed
  $os = `cat /etc/issue`
  # SMELL: deep hierarchy (run_autoclop -> autoclop -> invoke_clop_default -> invoke_clop)
  autoclop
end

def autoclop
  # SMELL: early returns can be confusing
  # SMELL: null check can be replaced by polymorphism
  return invoke_clop_default if $config.nil? || $config.empty?
  # SMELL: casual mutation of python_version
  # SMELL: default values spread throughout code
  python_version = 2
  # Red Hat has deprecated Python 2
  # SMELL: duplicated code (see invoke_clop_default)
  # SMELL: what happens when Red Hat 9 is released? (or, for that matter, Red Hat 80?)
  python_version = 3 if $os =~ /Red Hat 8/
  # SMELL: coupling to filesystem can be avoided
  # SMELL: primitive obsession: cfg is a hash
  cfg = YAML.safe_load(File.read($config))
  # SMELL: connascence of value :invalid_yaml
  # SMELL: null check can be replaced by polymorphism
  # SMELL: early returns can be confusing
  return invoke_clop_default :invalid_yaml if cfg.nil?
  # SMELL: null check can be encapsulated
  # SMELL: casual mutation of python_version
  python_version = cfg['python-version'] if cfg['python-version']
  # SMELL: null check can be encapsulated
  optimization = cfg['opt'] if cfg['opt']

  # SMELL: null check can be encapsulated
  # SMELL: nested control flow structures (if -> for -> if)
  if cfg['libs']
    # SMELL: casual mutation of `libargs`
    libargs = ''
    # SMELL: scope of `index` is larger than needed
    # SMELL: casual mutation of `index`
    index = 0
    for lib in cfg['libs']
      # SMELL: conceptual coupling of `libargs` to the shell via `esc`
      libargs << "-l#{esc lib}"
      # SMELL: overcomplicated code. All this logic can be replaced by a .map {...}.join(' ')
      if index < cfg['libs'].length - 1
        libargs << ' '
      end
      index += 1
    end
  elsif cfg['libdir']
    # SMELL: conceptual coupling of `libargs` to the shell via `esc`
    # SMELL: duplication (four places know about the -L flag)
    libargs = "-L#{esc cfg['libdir']}"
  elsif cfg['libdirs']
    # SMELL: duplicated code
    libargs = ''
    index = 0
    for libdir in cfg['libdirs']
      # SMELL: duplication (four places know about the -L flag)
      libargs << "-L#{esc libdir}"
      if index < cfg['libdirs'].length - 1
        libargs << ' '
      end
      index += 1
    end
  end
  # SMELL: default values spread throughout code
  # SMELL: coupling to ENV deep in call stack
  # SMELL: duplication (four places know about the -L flag)
  libargs ||= "-L/home/#{ENV['USER']}/.cbiscuit/lib"

  # SMELL: dead code (libargs will never be blank)
  # SMELL: default values spread throughout code
  invoke_clop(python_version, optimization || 'O2', libargs || '')
end

def invoke_clop_default(message_type=nil)
  # SMELL: default values spread throughout code
  # SMELL: duplicated code
  py = 2
  py = 3 if $os =~ /Red Hat 8/ # bugfix
  # SMELL: switch on type
  if message_type == :invalid_yaml
    # SMELL: system call deep in call stack
    # SMELL: reading globals deep in call stack
    # SMELL: multiple responsibilities (invoke_clop_default knows about default values and about printing warning messages)
    puts "WARNING: Invalid YAML in #{$config}. Assuming the default configuration."
  else
    puts "WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."
  end
  # SMELL: duplication (four places know about the -L flag)
  # SMELL: coupling to ENV deep in call stack
  # SMELL: default values spread throughout code
  invoke_clop(py, 'O2', "-L/home/#{ENV['USER']}/.cbiscuit/lib")
end

def invoke_clop(python_version, optimization = 'O1', libargs = '')
  # SMELL: casual mutation (reassignment to parameter)
  # SMELL: dead code. libargs will never be empty
  libargs = ' ' + libargs unless libargs.empty?
  # SMELL: system call deep in call stack
  # SMELL: primitive obsession (assembling args into shell string instead of forking directly)
  ok = Kernel.system "clop configure --python #{esc python_version} -#{esc optimization}#{libargs}"
  if !ok
    raise "clop failed. Please inspect the output above to determine what went wrong."
  end
end

def esc arg
  Shellwords.escape arg
end
