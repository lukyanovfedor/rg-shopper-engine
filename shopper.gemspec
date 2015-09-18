$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "shopper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "shopper"
  s.version     = Shopper::VERSION
  s.authors     = ["Lukyanov Fedor"]
  s.email       = ["lukyanov.f.ua@gmail.com"]
  s.homepage    = "https://github.com/lukyanovfedor/"
  s.summary     = "It't just business"
  s.description = "Adds shop to to your rails app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'aasm'
  s.add_dependency 'wicked'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'codeclimate-test-reporter'

  s.add_development_dependency 'pg'
end
