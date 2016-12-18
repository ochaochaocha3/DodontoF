source 'https://rubygems.org'

gem 'msgpack'

group :development, :test do
  if RUBY_VERSION < '1.9'
    gem 'rake', '~> 10.5'
    gem 'test-unit', '1.2.3'
  else
    gem 'rake'
    gem 'test-unit', '~> 3.2'
  end

  if RUBY_VERSION >= '1.9.3'
    gem 'mocha', '~> 1.2'
  end
end

group :fastcgi do
  if RUBY_VERSION >= '1.9.3'
    gem 'fcgi', '~> 0.9'
  end
end
