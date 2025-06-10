source 'https://rubygems.org'

gemspec

def get_env(name)
  (ENV[name] && !ENV[name].empty?) ? ENV[name] : nil
end

gem 'rails', '~> 8.0'
gem 'appraisal'
gem 'pry-rails'

db_gem = get_env("DB_GEM") || "sqlite3"
if db_gem == "sqlite3"
  gem db_gem, "~> 2.1"
else
  gem db_gem
end
