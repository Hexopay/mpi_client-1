Gem::Specification.new do |s|
  s.name         = 'mpi_client'
  s.version      = '0.3.3'
  s.authors      = ['Dmitry Plashchynski', 'Evgeniy Sugakov', 'Andrei Novikau']
  s.homepage     = 'http://github.com/ecomcharge/mpi_client/'
  s.summary      = 'MPI client library'
  s.email        = 'support@ecomcharge.com'
  s.require_path = "lib"
  s.files        = Dir.glob("lib/**/*.rb")
  s.add_dependency("nokogiri", [">= 1.10.4"])
  s.add_dependency("alovak-network", [">= 1.1.2"])
  s.add_dependency("activesupport", [">= 2.3.2"])
  s.add_development_dependency("rake")
  s.add_development_dependency("pry",[">= 0.12"])
  s.add_development_dependency("rspec", [">= 1.3.0"])
end
