require 'rubygems'
require 'gli'
require 'yaml'
require 'json'
require 'formatador'
require 'om_api_client'

require 'omcli/version'
require 'omcli/support/hash'

module OmCli
  autoload :CommandParser, 'omcli/command_parser'
  autoload :Processor,     'omcli/processor'
  autoload :Client,        'omcli/client'
  autoload :User,          'omcli/user'
  autoload :IO,            'omcli/io'
end
