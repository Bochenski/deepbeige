# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{deepbeige}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Bochenski"]
  s.date = %q{2010-09-05}
  s.description = %q{An AI learning program that plays board games}
  s.email = %q{david@bochenski.co.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "arena.rb",
     "deep_beige.rb",
     "deepbeige.gemspec",
     "game.rb",
     "human.rb",
     "lib/deepbeige.rb",
     "main.rb",
     "match.rb",
     "neural_net.rb",
     "node.rb",
     "noughts_and_crosses.rb",
     "pick_a_number.rb",
     "player.rb",
     "population/best.txt",
     "table.rb",
     "test/helper.rb",
     "test/test_deepbeige.rb",
     "tournament.rb",
     "ui/Rakefile",
     "ui/config/build.yml",
     "ui/lib/application.rb",
     "ui/lib/menu.rb",
     "ui/resources/DeepBeige.icns"
  ]
  s.homepage = %q{http://github.com/bochenski/deepbeige}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An AI learning program that plays board games}
  s.test_files = [
    "test/helper.rb",
     "test/test_deepbeige.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

