# coding: utf-8
# frozen_string_literal: true

module Kkmserver
  class CheckRow
    def initialize(args)
      args.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      set_defaults
    end

    def to_h
      result = {}
      if @text
        result['PrintText'] = {
          'Text' => @text,
          'Font' => @font,
          'Intensity' => @intensity
        }
      end

      if @register_name
        result['Register'] = {
          'Name' => @register_name,
          'Quantity' => @quantity,
          'Price' => @price,
          'Amount' => @amount,
          'Department' => @department,
          'Tax' => @tax,
          'EAN13' => @ean13,
          'SignMethodCalculation' => @payment_method,
          'SignCalculationObject' => @payment_object,
          'NomenclatureCode' => @nomenclature_code
        }
      end

      if @barcode
        result['BarCode'] = {'BarCodeType' => @barcode_type, 'Barcode' => @barcode}
      end

      result
    end

    private

    def set_defaults
      if @text
        @font ||= 0
        @intensity ||= 0
      end

      if @register_name
        @quantity ||= 1.0
        @amount ||= (@quantity * @price).round(2)
        @department ||= 0
        @tax ||= 18
        @payment_method ||= 4
        @payment_object ||= 1
        @nomenclature_code ||= ''
      end

      @barcode_type ||= 'EAN13' if @barcode
    end
  end
end
