source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3"

# The original asset pipeline for Rails
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server
gem "puma", "~> 6.4"

# Bundle and transpile JavaScript
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator
gem "turbo-rails"

# Hotwire's modest JavaScript framework
gem "stimulus-rails"

# Bundle and process CSS
gem "cssbundling-rails"

# Build JSON APIs with ease
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 5.2"

# Use Active Storage variants
# gem "image_processing", "~> 1.2"

# Execute jobs in the background
gem "sidekiq", "~> 7.2"

# HTTP client library
gem "httparty"

# SEO-friendly meta tags
gem "meta-tags"

# HTML, XML, SAX, and Reader parser
gem "nokogiri"

group :development, :test do
  # Debugging tools
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Reduces boot times through caching
  gem "bootsnap", require: false
end

group :development do
  # Use console on exceptions pages
  gem "web-console"

  # Add speed badges
  gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps
  # gem "spring"
end

group :test do
  # Use system testing
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
