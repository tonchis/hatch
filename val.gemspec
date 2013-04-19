Gem::Specification.new do |s|
  s.name        = 'val'
  s.version     = '0.0.1'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'Keep valid objects only'
  s.description = "An address without a street? A person without a name? You don't need no invalid objects!"
  s.authors     = ['Lucas Tolchinsky']
  s.email       = ['lucas.tolchinsky@gmail.com']
  s.homepage    = 'http://github.com/tonchis/val'
  s.license     = 'MIT'

  s.files = Dir[
    '*.gemspec',
    'Rakefile',
    'test/*.*'
  ]
end
