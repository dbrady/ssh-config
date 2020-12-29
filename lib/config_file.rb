require 'fileutils'

class ConfigFile
  def initialize(file_location = '~/.ssh/config', make_backups = true)
    @config_file_location = file_location
    @make_backups = make_backups
    @header_lines = []
    @sections = []
    @sections_by_name = {}
    read_config
  end

  def add_section(name)
    section = ConfigSection.new(name)
    @sections << section
    @sections_by_name[section.name] = section
    section
  end

  def read_config
    current_section = nil
    filename = File.expand_path(@config_file_location)
    return unless File.exist?(filename)
    IO.readlines(filename).each_with_index do |line, i|
      line.rstrip!
      if line =~ /\bHost\s+(.+)/
        current_section = add_section($1)
      else
        if current_section
          current_section.lines << line
        else
          @header_lines << line
        end
      end
    end
  end

  def show(*host_nicks)
    items =  host_nicks.map {|nick|
      sections = @sections.select {|section| section.matches_exactly?(nick)}
      sections.empty? ? "# No entry found for: #{nick}" : sections
    }
    items.flatten.uniq * "\n"
  end

  def list()
    to_text(@sections_by_name.keys.sort.map {|name| @sections_by_name[name].header})
  end

  def search(text)
    to_text(@sections.find_all {|section| section.matches?(text)}.sort_by {|section| section.name})
  end

  def set!(host_nick, *args)
    while args.length > 0
      key, value = args.shift, args.shift
      section = set(host_nick, key, value)
    end
    save
    section
  end

  def set(host_nick, key, value)
    section = @sections_by_name[host_nick] || add_section(host_nick)
    section[key] = value
  end

  def unset!(host_nick, *keys)
    while keys.length > 0
      section = unset(host_nick, keys.shift)
    end
    save
    section
  end

  def unset(host_nick, key)
    if section = @sections_by_name[host_nick]
      section.unset(key)
    end
  end

  def dump
    to_text([@header_lines, @sections].flatten)
  end

  def rm!(host_nick)
    rm(host_nick)
    save
  end

  def rm(host_nick)
    if @sections_by_name.key?(host_nick)
      @sections_by_name.delete host_nick
      @sections.delete_at(@sections.index{|s| s.name == host_nick})
    end
  end

  def copy!(old_host_nick, new_host_nick, *args)
    copy(old_host_nick, new_host_nick, *args)
    save
  end

  def copy(old_host_nick, new_host_nick, *args)
    if @sections_by_name.key?(old_host_nick)
      old_section = @sections_by_name[old_host_nick]
      new_section = @sections_by_name[new_host_nick] || add_section(new_host_nick)
      new_section.lines = old_section.lines.dup

      if old_section["Hostname"]
        new_section["Hostname"] = old_section["Hostname"].gsub(old_host_nick, new_host_nick)
      end

      while args.length > 0
        key, value = args.shift, args.shift
        section = set(new_host_nick, key, value)
      end
    end
  end

  def alias!(host_nick, *args)
    while args.length > 0
      new_alias = args.shift
      section = add_alias(host_nick, new_alias)
    end
    save
    section
  end

  def add_alias(host_nick, new_alias)
    section = @sections_by_name[host_nick] || add_section(host_nick)
    section.aliases.push(new_alias) unless section.aliases.member?(new_alias)
  end

  def unalias!(*args)
    if(args.size >= 2)
      name = args.shift
      section = @sections_by_name[name]
    else
      section = @sections.select {|section| section.has_alias?(args[0])}.first
    end

    if(section) then
      section.aliases -= args
    else
      $stderr.puts "Failed to find section named #{name || args[0]}"
    end
    save
    section
  end

  def save
    backup if @make_backups
    File.open(File.expand_path(@config_file_location), "w") do |file|
      file.puts dump
    end
  end

  def backup
    filename = File.expand_path(@config_file_location)
    FileUtils.copy(filename, filename + "~") if File.exist?(filename)
  end

  private

  def to_text(ray)
    ray.map {|s| s.to_s } * "\n"
  end
end
