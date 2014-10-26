$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'bundler'
Bundler.require
require 'aws-sdk-v1'

require 'rspec'
require 'factory_girl'

support_files = File.expand_path(File.join(File.dirname(__FILE__), 'support/**/*.rb'))
Dir.glob(support_files).each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus =>  true
  config.run_all_when_everything_filtered =  true
  config.order = "random"

  config.before(:all) do
    SetupSchema.suppress_migrate(:up)
    FactoryGirl.reload
  end

  config.before(:each) do
  end

  config.after(:each) do
  end

  config.after(:all) do
    SetupSchema.suppress_migrate(:down)
  end
end
