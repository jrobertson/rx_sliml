Gem::Specification.new do |s|
  s.name = 'rx_sliml'
  s.version = '0.1.2'
  s.summary = 'Generates an XML stylesheet or HTML string from a RecordX object.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/rx_sliml.rb']
  s.add_runtime_dependency('rexle-builder', '~> 0.2', '>=0.2.1')
  s.add_runtime_dependency('nokogiri', '~> 1.6', '>=1.6.2.1')
  s.add_runtime_dependency('kvx', '~> 0.5', '>=0.5.10')    
  s.signing_key = '../privatekeys/rx_sliml.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/rx_sliml'
end
