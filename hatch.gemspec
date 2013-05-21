Gem::Specification.new do |s|
  s.name        = 'hatch'
  s.version     = '0.0.6'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Keep valid objects only'
  s.description = "An address without a street? A person without a name? You don't need no invalid objects!"
  s.authors     = ['Lucas Tolchinsky']
  s.email       = ['lucas.tolchinsky@gmail.com']
  s.homepage    = 'http://github.com/tonchis/hatch'
  s.license     = 'MIT'

  s.files = Dir[
    'README.md',
    '*.gemspec',
    'Rakefile',
    'test/*.*',
    'lib/*.rb'
  ]
end
