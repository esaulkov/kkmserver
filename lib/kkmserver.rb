# coding: utf-8
# frozen_string_literal: true

require 'dotenv/load'
require 'json'
require 'rest-client'
require 'securerandom'
require 'kkmserver/cash_register'

module Kkmserver
  URL = ENV['KKMSERVER_URL']

  def self.list(*filters)
    result = send_command('List', filters)
    result['ListUnit'].map do |reg_data|
      Kkmserver::CashRegister.new(reg_data)
    end
  end

  def self.get_result(cmd_id)
    send_command('GetRezult', 'IdCommand' => cmd_id)
  end

  def self.send_command(command, options = {})
    params = {'Command' => command}.merge(options.to_h)
    resource = RestClient::Resource.new(Kkmserver::URL, user: 'Admin', password: 'admin')
    response = resource.post params.to_json, content_type: :json, accept: :json
    JSON.parse(response.body)
  end
end
