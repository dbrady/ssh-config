require 'spec_helper'

describe "ssh-config" do
  # ----------------------------------------------------------------------
  # Helper methods
  # ----------------------------------------------------------------------
  def add_example_hosts_to_ssh_config
    File.open(File.expand_path('~/.ssh/config'), 'a') do |f|
      f.puts("Host rspec1\n\tHostname rspec1.example.com")
      f.puts("Host rspec2\n\tHostname rspec2.example.com")
    end
  end

  def cleanup_example_hosts_from_ssh_config
    # ...
  end

  def run_ssh_config_command(command)
    system "./bin/ssh-config #{command} > ./spec/tmp/ssh-config-output.txt"
    File.read("./spec/tmp/ssh-config-output.txt")
  end

  # ----------------------------------------------------------------------
  # Specs
  # ----------------------------------------------------------------------
  before(:each) do
    add_example_hosts_to_ssh_config
  end

  context "sanity check" do
    it "is sane" do
      42.should == 42
    end
  end

  # NOTE: These are smoke tests, and as such they actually manipulate
  # your .ssh/config file. (!!!!) Do NOT put a spec in here that is
  # destructive! Ideally, back up .ssh/config, but assume that the
  # backup will be destroyed or useless--only spec changes that are
  # harmless. For example, don't try to remove all keys ending with
  # .com. Instead, use a before(:each) to add an rspec.example.com
  # host, then remove THAT, etc.

  describe "help" do
    it "displays help message" do
      run_ssh_config_command("help").should include("help - show this message")
    end
  end

  describe "list" do
    it "contains example hosts" do
      run_ssh_config_command("list").should include("rspec1")
      run_ssh_config_command("list").should include("rspec2")
    end
  end

  describe "show" do
    it 'shows a host section' do
      run_ssh_config_command("show rspec1").should include("Host rspec1\n\tHostname rspec1.example.com")
    end
  end

  describe "search"
  describe "cp"
  describe "copy"
  describe "unset"
  describe "set"
  describe "rm"
  describe "del"
  describe "delete"
  describe "dump"
  describe "alias"
  describe "unalias"
  describe "invalid command"

end
