# coding: utf-8
# frozen_string_literal: true

describe Kkmserver::CashRegister do
  let(:register) { Kkmserver.list.last }

  describe '#print_check' do
    context 'when check data are valid' do
      let(:check_params) do
        {
          type: 0,
          electronic: 301.50,
          rows: [
            {'PrintText' => {'Text' => '>#2#<ООО"Рога и копыта"', 'Font' => 1}},
            {'PrintText' => {'Text' => '<<->>'}},
            {'PrintText' => {'Text' => 'Пример №1:<#10#>154,41'}},
            {
              'PrintText' => {'Text' => 'Тестовый товар', 'Font' => 4, 'Intensity' => 0},
              'Register' => {
                'Name' => 'Сапоги женские DF-3099-1',
                'Quantity' => 3,
                'Price' => 100.50,
                'Amount' => 301.50,
                'Department' => 0,
                'Tax' => 18,
                'EAN13' => '1254789547853',
                'SignMethodCalculation' => 4,
                'SignCalculationObject' => 1,
                'MeasurementUnit' => 'пара',
                'NomenclatureCode' => ''
              },
              'BarCode' => {'BarcodeType' => 'EAN13', 'Barcode' => '1254789547853'}
            }
          ]
        }
      end

      subject { register.print_check(check_params) }

      it 'returns check number' do
        VCR.use_cassette('register') do
          expect(subject).to be_a(Hash)
          expect(subject.key?('CheckNumber')).to be_truthy
        end
      end
    end

    context 'when check data are invalid' do
      subject { register.print_check }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#open_shift' do
    subject { register.open_shift }

    context 'when shift is closed' do
      it 'returns check number' do
        VCR.use_cassette('open_shift') do
          expect(subject['CheckNumber']).to be_a(Integer)
        end
      end

      it 'returns shift number' do
        VCR.use_cassette('open_shift') do
          expect(subject['SessionNumber']).to be_a(Integer)
        end
      end
    end

    context 'when shift is open' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 60 : ККТ: Смена открыта – операция невозможна )'
        VCR.use_cassette('open_shift_error') do
          expect(subject['Error']).to eq(message)
        end
      end
    end
  end

  describe '#close_shift' do
    subject { register.close_shift }

    context 'when shift is open' do
      it 'returns check number' do
        VCR.use_cassette('close_shift') do
          expect(subject['CheckNumber']).to be_a(Integer)
        end
      end

      it 'returns shift number' do
        VCR.use_cassette('close_shift') do
          expect(subject['SessionNumber']).to be_a(Integer)
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('close_shift_error') do
          expect(subject.key?('Error')).to be_truthy
          expect(subject['Error']).to eq(message)
        end
      end
    end
  end

  describe '#depositing_cash' do
    subject { register.depositing_cash(1.01) }

    context 'when shift is open' do
      it 'returns zero state' do
        VCR.use_cassette('depositing_cash') do
          expect(subject['Status']).to eq(0)
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('depositing_cash_error') do
          expect(subject['Error']).to eq(message)
        end
      end
    end
  end

  describe '#payment_cash' do
    subject { register.payment_cash(0.65) }

    context 'when shift is open' do
      it 'returns zero state' do
        VCR.use_cassette('payment_cash') do
          expect(subject['Status']).to eq(0)
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('payment_cash_error') do
          expect(subject['Error']).to eq(message)
        end
      end
    end
  end

  describe '#x_report' do
    subject { register.x_report }

    it 'returns zero state' do
      VCR.use_cassette('x_report') do
        expect(subject['Status']).to eq(0)
      end
    end
  end

  describe '#z_report' do
    subject { register.z_report }

    context 'when shift is open' do
      it 'returns check number' do
        VCR.use_cassette('z_report') do
          expect(subject['CheckNumber']).to be_a(Integer)
        end
      end

      it 'returns shift number' do
        VCR.use_cassette('z_report') do
          expect(subject['SessionNumber']).to be_a(Integer)
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('z_report_error') do
          expect(subject['Error']).to eq(message)
        end
      end
    end
  end

  describe '#open_cash_drawer' do
    subject { register.open_cash_drawer }

    it 'returns zero state' do
      VCR.use_cassette('open_cash_drawer') do
        expect(subject['Status']).to eq(0)
      end
    end
  end

  describe '#line_length' do
    subject { register.line_length }

    it 'returns a number' do
      VCR.use_cassette('line_length') do
        expect(subject).to be_a(Integer)
      end
    end
  end

  describe '#check' do
    subject { register.check }

    it 'returns a slip' do
      VCR.use_cassette('get_check') do
        expect(subject['Slip']).to be_a(String)
      end
    end

    it 'returns a check content' do
      VCR.use_cassette('get_check') do
        expect(subject['RegisterCheck']).to be_a(Hash)
      end
    end
  end
end
