module SSHConfig
  class ConfigSection
    attr_accessor :name, :lines, :settings

    def initialize(name)
      @name = name
      @settings = {}
      @lines = []
    end

    def [](setting)
      unless @settings.key? setting
        if line = lines[setting_index(setting)]
          key,val = line.split(nil, 2)
          @settings[key] = val
        end
      end
      @settings[setting]
    end

    def unset(setting)
      if line_num = setting_index(setting)
        @settings.delete setting
        @lines.delete_at line_num
      end
    end

    def to_s
      ["Host #{name}", *lines] * "\n"
    end

    def []=(setting, value)
      if value != '-'
        line_num = setting_index(setting) || lines.length
        lines[line_num] = format_line(setting, value)
      else
        @settings.delete(setting)
        @lines.delete_at(setting_index(setting))
      end
    end

    def matches?(text)
      r = Regexp.new text
      name =~ r || lines.any? {|line| line =~ r}
    end

    protected

    def format_line(setting, value)
      "    #{setting} #{value}"
    end

    def setting_index(setting)
      r = Regexp.new(setting)
      lines.index {|line| line =~ r}
    end
  end

end
