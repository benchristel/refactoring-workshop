Here is one possible solution to the `autoclop` kata. The
code below resulted from applying a sequence of 39
small refactorings to the starter code. You can see the
sequence of refactorings on the `bc-autoclop-solution`
branch.

The process I used went like this:

1. Identify a smell that's easy to fix.
2. Fix it.
3. Commit.
4. Go to step 1.

It's important to note that this solution is *not*
"designed" in the usual sense of the word. I didn't plan out
how the code would ultimately look. I just applied
refactorings in response to smells, working on whatever
smell was salient and easy to fix in that moment.

In an earlier attempt at this kata, I *did* try to
consciously design the code, and I ran into a dead end. That
attempt is recorded on a branch `bc-smells-1`.

There are things I would probably change about this code if
I were designing parts of it upfront. The interface to
Kernel.system, for instance, could probably be improved with
a function that would join an array of raw arguments into a
properly escaped shell command. The purpose of this solution
is not to showcase an "optimal" design, but to demonstrate
how thoroughly you can clean up code just by following the
smells and applying simple refactorings.

------------------------------------------------------------

```ruby
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
```
