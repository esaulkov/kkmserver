# coding: utf-8
# frozen_string_literal: true

module Kkmserver
  class CashRegister
    def initialize(args)
      args.each do |key, value|
        var_name = key.gsub(/(.[a-z])([A-Z])/,'\1_\2').downcase
        instance_variable_set("@#{var_name}", value)
      end
    end
  end
end
