require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# https://github.com/ludicast/yaml_db/issues/21
require 'yaml'
YAML::ENGINE.yamler= 'syck'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
