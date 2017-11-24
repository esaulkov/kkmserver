# coding: utf-8
# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'rest-client'
require 'kkmserver/cash_register'

module Kkmserver
  URL = ENV['KKMSERVER_URL']

  def self.list(*filters)
    response = send_command('List', filters)
    if response.code == 200
      result = JSON.parse(response.body)
      result['ListUnit'].map do |reg_data|
        Kkmserver::CashRegister.new(reg_data)
      end
    end
  end

  def self.get_result(cmd_id)
    send_command('GetRezult', 'IdCommand' => cmd_id)
  end

  def self.send_command(command, options={})
    params = {'Command' => command}.merge(options.to_h)
    resource = RestClient::Resource.new(Kkmserver::URL, :user => 'Admin', :password => 'admin' )
    resource.post params.to_json, {content_type: :json, accept: :json}
  end
end
