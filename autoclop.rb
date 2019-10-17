require 'shellwords'
require 'yaml'

def run_autoclop
  os = File.read('/etc/issue')
  Autoclop.new(os, ENV).autoclop
end

class Autoclop
  def initialize(os, env)
    @os = os
    @env = env
  end

  class Config
    def initialize(os, env)
      @os = os
      @env = env
    end

    def warnings
      []
    end

    def python_version
      default_python_version
    end

    def optimization
      'O2'
    end

    def libargs
      "-L/home/#{esc @env['USER']}/.cbiscuit/lib"
    end

    private

    def esc arg
      Shellwords.escape arg
    end

    def default_python_version
      @os =~ /Red Hat 8/ ? 3 : 2 # Red Hat has deprecated Python 2
    end
  end

  class NoFileGivenConfig < Config
    def warnings
      ["WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration."]
    end
  end

  class InvalidYamlConfig < Config
    def warnings
      ["WARNING: Invalid YAML in #{@env['AUTOCLOP_CONFIG']}. Assuming the default configuration."]
    end
  end

  class ValidConfig < Config
    def initialize(os, env, cfg)
      @os = os
      @env = env
      @cfg = cfg
    end

    def python_version
      cfg['python-version'] || default_python_version
    end

    def optimization
      cfg['opt'] || 'O2'
    end

    def libargs
      flag, libargs =
        if cfg['libs']
          ["-l", cfg['libs']]
        elsif cfg['libdir']
          ["-L", [cfg['libdir']]]
        elsif cfg['libdirs']
          ["-L", cfg['libdirs']]
        else
          ["-L", ["/home/#{@env['USER']}/.cbiscuit/lib"]]
        end

      libargs.map { |arg| "#{flag}#{esc arg}" }.join(' ')
    end

    private

    def cfg
      @cfg
    end
  end

  def autoclop
    config =
      if config_path.to_s.empty?
        NoFileGivenConfig.new(@os, @env)
      elsif cfg.nil?
        InvalidYamlConfig.new(@os, @env)
      else
        ValidConfig.new(@os, @env, cfg)
      end

    config.warnings.each { |warning| Kernel.puts warning }
    ok = Kernel.system "clop configure --python #{esc config.python_version} -#{esc config.optimization} #{config.libargs}".strip
    if !ok
      raise "clop failed. Please inspect the output above to determine what went wrong."
    end
  end

  private

  def cfg
    YAML.safe_load(File.read(config_path))
  end

  def config_path
    @env['AUTOCLOP_CONFIG']
  end

  def esc arg
    Shellwords.escape arg
  end
end
