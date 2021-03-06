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
        params = base_params.merge(
          'NotPrint' => !print,
          'CashierName' => @name_organization,
          'CashierVATIN' => @inn
        )
        Kkmserver.send_command("#{action.capitalize}Shift", params)
      end
    end

    %w[depositing payment].each do |action|
      define_method("#{action}_cash") do |amount|
        params = base_params.merge(
          'Amount' => amount.to_f.round(2),
          'CashierName' => @name_organization,
          'CashierVATIN' => @inn
        )
        Kkmserver.send_command("#{action.capitalize}Cash", params)
      end
    end

    def check(number = 0, copies = 1)
      params = base_params.merge(
        'FiscalNumber' => number,
        'NumberCopies' => copies
      )
      Kkmserver.send_command('GetDataCheck', params)
    end

    def line_length
      @line_length ||= begin
        result = Kkmserver.send_command('GetLineLength', base_params)
        result['LineLength'] if result['Status'].zero?
      end
    end

    def open_cash_drawer
      Kkmserver.send_command('OpenCashDrawer', base_params)
    end

    def print_check(params)
      is_fiscal = params[:fiscal].nil? ? true : params[:fiscal]
      params =  base_params
                .merge(payments(params))
                .merge(
                  'IsFiscalCheck' => is_fiscal,
                  'TypeCheck' => params[:type],
                  'NotPrint' => params[:not_print] || false,
                  'NumberCopies' => params[:copies] || 0,
                  'CashierName' => @name_organization,
                  'CashierVATIN' => @inn,
                  'TaxVariant' => @tax_variant,
                  'ClientAddress' => '',
                  'CheckStrings' => params[:rows]
                )
      Kkmserver.send_command('RegisterCheck', params)
    end

    def state
      Kkmserver.send_command('GetDataKKT', base_params)
    end

    def x_report
      Kkmserver.send_command('XReport', base_params)
    end

    def z_report
      Kkmserver.send_command('ZReport', base_params)
    end

    private

    def payments(values)
      raise ArgumentError, 'Sum of payments should be non-zero' unless valid_payment?(values)

      {
        'Cash' => values[:cash].to_f,
        'ElectronicPayment' => values[:electronic].to_f,
        'AdvancePayment' => values[:advance].to_f,
        'Credit' => values[:credit].to_f,
        'CashProvision' => values[:provision].to_f
      }
    end

    def valid_payment?(values)
      %i[cash electronic advance credit provision].any? do |payment_type|
        values[payment_type].to_f.positive?
      end
    end

    def base_params
      {
        'NumDevice' => @num_device,
        'IdCommand' => SecureRandom.uuid
      }
    end
  end
end
