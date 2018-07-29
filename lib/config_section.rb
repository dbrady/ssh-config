class ConfigSection
  attr_accessor :name, :aliases, :lines, :settings

  def initialize(name)
    all_names = name.split(/\s+/)
    @name = all_names.shift
    @aliases = all_names
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

  def header
    name_with_aliases = [@name, *aliases].join(" ")
    "Host #{name_with_aliases}"
  end

  def to_s
    [header, *lines] * "\n"
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
    name =~ r || aliases.any? {|a| a =~ r} || lines.any? {|line| line =~ r}
  end

  def matches_exactly?(text)
    name == text || has_alias?(text)
  end

  def has_alias?(text)
    aliases.member?(text)
  end

  protected

  def format_line(setting, value)
    "    #{setting} #{value}"
  end

  def setting_index(setting)
    # according to the ssh_config man page keys are _case insensitive_
    r = Regexp.new(setting, Regexp::IGNORECASE)
    lines.index {|line| line =~ r}
  end
end
