class ConfigFile
  def initialize
    @make_backups = true
    @header_lines = []
    @sections = []
    @sections_by_name = {}
    read_config
  end
  
  def add_section(name)
    section = ConfigSection.new(name)
    @sections << section
    @sections_by_name[name] = section
    section
  end
  
  def read_config
    current_section = nil
    IO.readlines(File.expand_path("~/.ssh/config")).each_with_index do |line, i|
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
  
  def show(host_nick)
    @sections_by_name[host_nick]
  end
  
  def list()
    to_text(@sections_by_name.keys.sort.map {|name| "Host #{name}"})
  end
  
  def search(text)
    to_text(@sections.find_all {|section| section.matches?(text)}.sort_by {|section| section.name})
  end

  def set!(host_nick, *args)
    backup if @make_backups
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
    backup if @make_backups
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
    backup if @make_backups
    rm(host_nick)
    save
  end
  
  def rm(host_nick)
    if @sections_by_name.key?(host_nick)
      @sections_by_name.delete host_nick
      @sections.delete_at(@sections.index{|s| s.name == host_nick})
    end
  end
  
  def copy!(old_host_nick, new_host_nick)
    backup if @make_backups
    copy(old_host_nick, new_host_nick)
    save
  end
  
  def copy(old_host_nick, new_host_nick)
    if @sections_by_name.key?(old_host_nick)
      old_section = @sections_by_name[old_host_nick]
      new_section = @sections_by_name[new_host_nick] || add_section(new_host_nick)
      new_section.lines = old_section.lines.dup
      
      if old_section["Hostname"]
        new_section["Hostname"] = old_section["Hostname"].gsub(old_host_nick, new_host_nick)
      end
    end
  end
    
  def save
    File.open(File.expand_path("~/.ssh/config"), "w") do |file|
      file.puts dump
    end
  end
  
  def backup
    File.copy(File.expand_path("~/.ssh/config"), File.expand_path("~/.ssh/config~"))
  end
    
  private
  
  def to_text(ray)
    ray.map {|s| s.to_s } * "\n"
  end
end

