require 'ssh-config'
require 'tempfile'

describe ConfigFile do

  examples_dir = File.expand_path('../examples', __FILE__)

  before(:each) do
    @file = Tempfile.new('ssh_config')
  end

  after(:each) do
    @file.close
    @file.unlink
  end

  it 'adds an entry to an empty file' do
      config_file = ConfigFile.new(@file.path, false)

      config_file.add_section('loltest')
      config_file.set('loltest', 'HostName', 'loltest.example.com')

      config_file.save

      output = File.read(@file)

      expect(output).to eq(<<~EOF
Host loltest
    HostName loltest.example.com
                        EOF
                        )
  end

  it 'adds an entry to an existing file' do
    @file.write(File.read(File.join(examples_dir, 'existing.ssh_config')))

    @file.flush

    config_file = ConfigFile.new(@file.path, false)

    config_file.add_section('test1')
    config_file.set('test1', 'User', 'dkowis')
    config_file.set('test1', 'HostName', 'test1.example.com')

    config_file.save

    output = File.read(@file)

    expect(output).to eq(<<~EOF
Host loltest2
  HostName this.is.my.host
  User lol
Host test1
    User dkowis
    HostName test1.example.com
EOF
)

  end

  it 'removes an entry from an existing file'
  it 'removes an entry that it added'
  it 'copies one entry to another'
  it 'updates an existing entry'
  it 'saves a backup file'
end