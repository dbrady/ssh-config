spec = Gem::Specification.new do |s|
  s.name = 'ssh-config'
  s.version = '0.1.2'
  s.date = '2010-03-29'
  s.summary = 'Ssh-Config - tool for managing your .ssh/config file'
  s.email = "github@shinybit.com"
  s.homepage = "http://github.com/dbrady/ssh-config/"
  s.description = "Ssh-Config, a tool that lets you quickly add, update, remove, and copy ssh config file entries."
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.rdoc", "--title", "Ssh-Config - A Tool for ssh config files"]
  s.executables = ["ssh-config"]
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE", "CHANGES"]
  s.authors = ["David Brady"]

  # ruby -rpp -e "pp (Dir['{README*,CHANGES*,MIT-LICENSE,{examples,lib,protocol,spec}/**/*.{rdoc,json,rb,txt,xml,yml}}'] + Dir['bin/*']).map.sort"
  s.files = ["CHANGES",
    "MIT-LICENSE",
    "README.rdoc",
    "bin/ssh-config",
    "lib/config_file.rb",
    "lib/config_section.rb",
    "lib/ssh-config.rb"]
end

