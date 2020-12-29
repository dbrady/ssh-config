spec = Gem::Specification.new do |s|
  s.name = 'ssh-config'
  s.version = '0.1.4'
  s.date = '2011-02-09'
  s.summary = 'Ssh-Config - tool for managing your .ssh/config file'
  s.email = "github@shinybit.com"
  s.homepage = "http://github.com/dbrady/ssh-config/"
  s.description = "Ssh-Config, a tool that lets you quickly add, update, remove, and copy ssh config file entries."
  s.executables = ["ssh-config"]
  s.authors = ["David Brady"]

  # ruby -rpp -e "pp (Dir['{README*,CHANGES*,MIT-LICENSE,{examples,lib,protocol,spec}/**/*.{rdoc,json,rb,txt,xml,yml}}'] + Dir['bin/*']).map.sort"
  s.files = ["CHANGES",
    "MIT-LICENSE",
    "README.rdoc",
    "bin/ssh-config",
    "lib/config_file.rb",
    "lib/config_section.rb",
    "lib/ssh-config.rb"]

  s.add_development_dependency 'rspec-core', '3.7'
  s.add_development_dependency 'rspec-expectations', '3.7'
  s.add_development_dependency 'simplecov', '0.20.0'
end
