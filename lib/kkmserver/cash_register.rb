# coding: utf-8
# frozen_string_literal: true

module Kkmserver
  class CashRegister
    def initialize(args)
      args.each do |key, value|
        var_name = key.gsub(/(.[a-z])([A-Z])/, '\1_\2').downcase
        instance_variable_set("@#{var_name}", value)
      end
    end

    %w[close open].each do |action|
      define_method("#{action}_shift") do |print = true|
        result = Kkmserver.send_command(
          "#{action.capitalize}Shift",
          'NumDevice' => @num_device,
          'IdCommand' => SecureRandom.uuid,
          'NotPrint' => !print,
          'CashierName' => @name_organization,
          'CashierVATIN' => @inn
        )
        result['Status'].zero? ? result : result['Error']
      end
    end

    def print_check(params)
      raise ArgumentError, 'Sum of payments should be non-zero' unless check_payments(params)

      is_fiscal = params[:fiscal].nil? ? true : params[:fiscal]
      result = Kkmserver.send_command(
        'RegisterCheck',
        {
          'NumDevice' => @num_device,
          'IdCommand' => SecureRandom.uuid,
          'IsFiscalCheck' => is_fiscal,
          'TypeCheck' => params[:type],
          'NotPrint' => params[:not_print] || false,
          'NumberCopies' => params[:copies] || 0,
          'CashierName' => params[:cashier_name],
          'CashierVATIN' => @inn,
          'ClientAddress' => '',
          'TaxVariant' => '',
          'CheckStrings' => params[:rows],
          'Cash' => params[:cash].to_f,
          'ElectronicPayment' => params[:electronic].to_f,
          'AdvancePayment' => params[:advance].to_f,
          'Credit' => params[:credit].to_f,
          'CashProvision' => params[:provision].to_f
        }
      )
      result['Status'].zero? ? result['CheckNumber'] : result['Error']
    end

    def state
      Kkmserver.send_command(
        'GetDataKKT',
        'NumDevice' => @num_device,
        'IdCommand' => SecureRandom.uuid
      )
    end

    private

    def check_payments(values)
      %i[cash electronic advance credit provision].any? do |payment_type|
        values[payment_type].to_f.positive?
      end
    end
  end
end
