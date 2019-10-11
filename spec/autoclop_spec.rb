require 'rspec'
require 'fileutils'
require_relative '../autoclop'

describe 'Configuring `clop`' do
  let(:user) { 'testuser' }

  before :each do
    $config = nil
    $os = nil
    ENV['USER'] = user
    FileUtils.rm_f('/tmp/test-file-deleteme')
    allow(Kernel).to receive(:system).and_return true
    allow(Kernel).to receive(:puts)
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with('/etc/issue').and_return('linux')
  end

  def config=(yaml)
    ENV['AUTOCLOP_CONFIG'] = '/tmp/test-file-deleteme'
    File.write('/tmp/test-file-deleteme', yaml)
  end

  shared_examples_for 'the defaults' do
    it 'uses the defaults' do
      run_autoclop
      expect(Kernel).to have_received(:system).with("clop configure --python 2 -O2 -L/home/#{user}/.cbiscuit/lib")
    end

    context 'on Red Hat 8' do
      before :each do
        allow(File).to receive(:read).with('/etc/issue')
          .and_return('blah blah Red Hat 8 blah')
      end

      it 'uses python 3' do
        run_autoclop
        expect(Kernel).to have_received(:system).with("clop configure --python 3 -O2 -L/home/#{user}/.cbiscuit/lib")
      end
    end
  end

  context 'if you do not provide a config file path' do
    before(:each) { ENV['AUTOCLOP_CONFIG'] = nil }

    it_behaves_like 'the defaults'

    it 'warns' do
      run_autoclop
      expect(Kernel).to have_received(:puts).with('WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration.')
    end
  end

  context 'given an empty config file path' do
    before(:each) { ENV['AUTOCLOP_CONFIG'] = '' }

    it_behaves_like 'the defaults'

    it 'warns' do
      run_autoclop
      expect(Kernel).to have_received(:puts).with('WARNING: No file specified in $AUTOCLOP_CONFIG. Assuming the default configuration.')
    end
  end

  context 'given a file that is not YAML' do
    before :each do
      file = '/tmp/test-file-deleteme'
      FileUtils.touch file
      ENV['AUTOCLOP_CONFIG'] = file
    end

    it_behaves_like 'the defaults'

    it 'warns' do
      run_autoclop
      expect(Kernel).to have_received(:puts).with('WARNING: Invalid YAML in /tmp/test-file-deleteme. Assuming the default configuration.')
    end
  end

  context 'on Red Hat 8' do
    before :each do
      allow(File).to receive(:read).with('/etc/issue')
        .and_return('Linux version 2.6.32-71.el6.x86_64 (mockbuild@c6b6.centos.org) (gcc version 4.4.4 20100726 (Red Hat 8.0.0) (GCC) ) #1 SMP Fri May 20 03:51:51 BST 2011  ')
      self.config = "---\n{}"
    end

    it 'uses python 3' do
      run_autoclop
      expect(Kernel).to have_received(:system).with("clop configure --python 3 -O2 -L/home/#{user}/.cbiscuit/lib")
    end
  end

  it 'uses the python version specified in the config file, if any' do
    self.config = <<-EOF
---
python-version: 2.7
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with("clop configure --python 2.7 -O2 -L/home/#{user}/.cbiscuit/lib")
  end

  it 'uses the optimization level specified in the config file, if any' do
    self.config = <<-EOF
---
opt: O0
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with("clop configure --python 2 -O0 -L/home/#{user}/.cbiscuit/lib")
  end

  it 'gets libs from a specified directory' do
    self.config = <<-EOF
---
libdir: /foo/bar
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/foo/bar')
  end

  it 'gets libs from multiple directories' do
    self.config = <<-EOF
---
libdirs:
- /foo/bar
- /baz/quux
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/foo/bar -L/baz/quux')
  end

  it 'loads specific libraries' do
    self.config = <<-EOF
---
libs:
- /foo/liba.1.0
- /foo/libb.2.0
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -l/foo/liba.1.0 -l/foo/libb.2.0')
  end

  it 'handles libraries with spaces in their names' do
    self.config = <<-EOF
---
libs:
- /foo/weird lib.1.0
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -l/foo/weird\ lib.1.0')
  end

  it 'blocks shell injection attacks that exploit the optimization level' do
    self.config = <<-EOF
---
opt: '$(echo hacked > /tmp/foo)'
libs: []
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -\$\(echo\ hacked\ \>\ /tmp/foo\)')
  end

  it 'blocks shell injection attacks that exploit the python version' do
    self.config = <<-EOF
---
python-version: '$(echo hacked > /tmp/foo)'
libs: []
EOF
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python \$\(echo\ hacked\ \>\ /tmp/foo\) -O2')
  end

  it 'blocks shell injection attacks that exploit the USER env variable' do
    ENV['USER'] = '$(echo hacked > /tmp/foo)'
    self.config = ''
    run_autoclop
    expect(Kernel).to have_received(:system).with(include('\$\(echo\ hacked\ \>\ /tmp/foo\)'))
  end

  it 'blocks shell injection attacks that exploit the USER env variable, when a config file is given' do
    self.config = <<-EOF
---
python-version: 2
EOF
    ENV['USER'] = '$(echo hacked > /tmp/foo)'
    run_autoclop
    expect(Kernel).to have_received(:system).with(include('\$\(echo\ hacked\ \>\ /tmp/foo\)'))
  end

  it 'raises an error if clop fails' do
    self.config = '{}'
    allow(Kernel).to receive(:system).and_return(false)
    expect { run_autoclop }.to raise_error 'clop failed. Please inspect the output above to determine what went wrong.'
  end
end
