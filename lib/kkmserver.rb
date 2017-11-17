# coding: utf-8
# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'rest-client'

class Kkmserver
  URL = ENV['KKMSERVER_URL']

  class << self

    def list(*filters)
      send_command('List', filters)
    end

    def get_result(cmd_id)
      send_command('GetRezult', 'IdCommand' => cmd_id)
    end

    def send_command(command, options={})
      params = {'Command' => command}.merge(options.to_h)
      resource = RestClient::Resource.new(Kkmserver::URL, :user => 'Admin', :password => 'admin' )
      resource.post params.to_json, {content_type: :json, accept: :json}
    end
  end
end
