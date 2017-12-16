# coding: utf-8
# frozen_string_literal: true

describe Kkmserver::CheckRow do
  context 'when row is a text' do
    subject { described_class.new(text: 'Test good') }

    it 'assigns the text to variable' do
      h = subject.to_h
      expect(h['PrintText']['Text']).to eq('Test good')
    end

    it 'fills default values' do
      h = subject.to_h
      expect(h['PrintText']['Font']).to eq(0)
      expect(h['PrintText']['Intensity']).to eq(0)
    end
  end

  context 'when row is a fiscal data' do
    subject { described_class.new(register_name: 'sold item', price: 45.76, ean13: '1254789547853') }

    it 'assigns the data to variables' do
      h = subject.to_h
      expect(h['Register']['Name']).to eq('sold item')
      expect(h['Register']['Price']).to eq(45.76)
      expect(h['Register']['EAN13']).to eq('1254789547853')
    end

    it 'fills default values' do
      h = subject.to_h
      expect(h['Register']['Quantity']).to eq(1.0)
      expect(h['Register']['Amount']).to eq(45.76)
      expect(h['Register']['Department']).to eq(0)
      expect(h['Register']['Tax']).to eq(18)
      expect(h['Register']['SignMethodCalculation']).to eq(4)
      expect(h['Register']['SignCalculationObject']).to eq(1)
      expect(h['Register']['NomenclatureCode']).to eq('')
    end
  end

  context 'when row is a barcode' do
    subject { described_class.new(barcode: '1254789547853') }

    it 'assigns the barcode to variable' do
      h = subject.to_h
      expect(h['BarCode']['Barcode']).to eq('1254789547853')
    end

    it 'fills default values' do
      h = subject.to_h
      expect(h['BarCode']['BarCodeType']).to eq('EAN13')
    end
  end
end
