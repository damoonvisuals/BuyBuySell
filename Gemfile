source 'https://rubygems.org'

gem 'rails', '3.2.13'
# gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'

gem 'devise'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# gem 'omniauth'

gem 'twitter-bootstrap-rails'

gem 'jquery-rails', '2.0.2'
gem 'mailboxer'
gem 'simple_form'

gem 'acts_as_commentable', '3.0.1'
gem "acts_as_rateable", :git => "git://github.com/anton-zaytsev/acts_as_rateable.git"
gem 'acts-as-taggable-on'
gem 'rmagick'
gem 'carrierwave'

gem 'pg_search'
gem 'impressionist'

group :development, :test do
  # gem 'sqlite3', '1.3.5'
  gem 'pg', '0.15.0'
  # gem 'taps'
  gem 'rspec-rails', '2.11.0'
end

group :development do
  gem 'annotate', '2.5.0'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '3.2.5'
  #gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '1.2.3'
  
  gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
  gem 'therubyracer', :platforms => :ruby
  # gem 'angularjs-rails'
end

group :test do
  gem 'capybara', '1.1.2'
  gem 'factory_girl_rails', '4.1.0'

  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
end

group :production do
  gem 'pg', '0.15.0'
end

gem 'rack-no-www', '0.0.2'
gem "kaminari"
gem 'thin'