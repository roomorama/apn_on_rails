require 'rubygems'
require 'rspec'
require 'action_view'

Dir.glob(File.join(File.dirname(__FILE__), 'extensions', '*.rb')).sort.each do |f|
  require f
end

require File.join(File.dirname(__FILE__), 'active_record', 'setup_ar.rb')

require File.join(File.dirname(__FILE__), '..', 'lib', 'apn_on_rails')

# Dir.glob(File.join(File.dirname(__FILE__), 'factories', '*.rb')).sort.each do |f|
#   require f
# end

require File.join(File.dirname(__FILE__), 'factories', 'app_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'device_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'group_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'device_grouping_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'group_notification_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'notification_factory.rb')
require File.join(File.dirname(__FILE__), 'factories', 'pull_notification_factory.rb')

configatron.apn.cert = File.expand_path(File.join(File.dirname(__FILE__), 'rails_root', 'config', 'apple_push_notification_development.pem'))

RSpec.configure do |config|
  
  config.before(:all) do
    
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do

  end
  
  config.after(:each) do
    
  end
  
  if defined?(ActiveRecord::Base)
    begin
      require 'database_cleaner'
      config.before(:suite) do
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean_with(:truncation)
      end

      config.before(:each) do
        DatabaseCleaner.start
      end

      config.after(:each) do
        DatabaseCleaner.clean
      end

    rescue LoadError => ignore_if_database_cleaner_not_present
    end
  end
  
end

def fixture_path(*name)
  return File.join(File.dirname(__FILE__), 'fixtures', *name)
end

def fixture_value(*name)
  if RUBY_VERSION =~ /^1\.8/
    File.read(fixture_path(*name))
  else
    File.read(fixture_path(*name), :encoding  => 'BINARY')
  end
end

def write_fixture(name, value)
  File.open(fixture_path(*name), 'w') {|f| f.write(value)}
end

def apn_cert
  File.read(File.join(File.dirname(__FILE__), 'rails_root', 'config', 'apple_push_notification_development.pem'))
end

class BlockRan < StandardError
end

RSpec::Matchers.define :be_same_meaning_as do |expected|
  match do |actual|
    ActiveSupport::JSON.decode(actual) == ActiveSupport::JSON.decode(expected)
  end
end