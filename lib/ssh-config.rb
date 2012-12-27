require "config_file"
require "config_section"

module SSHConfig
  class << self
    def file
      @file ||= SSHConfig::ConfigFile.new
    end
  end
end
