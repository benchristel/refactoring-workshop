require 'rspec'
require 'fileutils'
require_relative '../autoclop'

describe 'Configuring `clop`' do
  before :each do
    FileUtils.rm_f('/tmp/test-file-deleteme')
    allow(Kernel).to receive(:system).and_return true
    allow(Kernel).to receive(:puts).and_return nil
    allow(File).to receive(:read).and_call_original
    allow(File).to receive(:read).with('/etc/issue').and_return ''
  end

  it 'uses the defaults if you do not provide a config file path' do
    ENV['AUTOCLOP_CONFIG'] = nil
    ENV['USER'] = 'Ben'
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/home/Ben/.cbiscuit/lib')
    expect(Kernel).to have_received(:puts).with(%r{No file specified})
  end

  it 'uses the defaults if you provide a file that is not YAML' do
    file = '/tmp/test-file-deleteme'
    FileUtils.touch file
    ENV['AUTOCLOP_CONFIG'] = file
    ENV['USER'] = 'Ben'
    run_autoclop
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/home/Ben/.cbiscuit/lib')
    expect(Kernel).to have_received(:puts).with(%r{Invalid YAML in /tmp/test-file-deleteme})
  end

  it 'uses python 3 on Red Hat 8' do
    os = 'Linux version 2.6.32-71.el6.x86_64 (mockbuild@c6b6.centos.org) (gcc version 4.4.4 20100726 (Red Hat 8.0.0) (GCC) ) #1 SMP Fri May 20 03:51:51 BST 2011  '
    config = ''
    autoclop(os, config, 'Ben')
    expect(Kernel).to have_received(:system).with('clop configure --python 3 -O2 -L/home/Ben/.cbiscuit/lib')
  end

  it 'uses the python version specified in the config file, if any' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
python-version: 2.7
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2.7 -O2 -L/home/Ben/.cbiscuit/lib')
  end

  it 'uses the optimization level specified in the config file, if any' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
opt: O0
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O0 -L/home/Ben/.cbiscuit/lib')
  end

  it 'gets libs from a specified directory' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
libdir: /foo/bar
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/foo/bar')
  end

  it 'gets libs from multiple directories' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
libdirs:
- /foo/bar
- /baz/quux
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -L/foo/bar -L/baz/quux')
  end

  it 'loads specific libraries' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
libs:
- /foo/liba.1.0
- /foo/libb.2.0
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -l/foo/liba.1.0 -l/foo/libb.2.0')
  end

  it 'handles libraries with spaces in their names' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
libs:
- /foo/weird lib.1.0
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 -l/foo/weird\ lib.1.0')
  end

  it 'passes no -l or -L flags if you specify an empty library list' do
    config = '/tmp/test-file-deleteme'
    File.write(config, <<-EOF)
---
libs: []
EOF
    autoclop nil, config, 'Ben'
    expect(Kernel).to have_received(:system).with('clop configure --python 2 -O2 ')
  end
end
