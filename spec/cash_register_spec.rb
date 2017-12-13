# coding: utf-8
# frozen_string_literal: true

describe Kkmserver::CashRegister do
  let(:register) { Kkmserver.list.last }

  describe '#print_check' do
    context 'when check data are valid' do
      subject { register.print_check(type: 0, cashier_name: 'Ivanov S.A.', electronic: 100) }

      it 'returns check number' do
        VCR.use_cassette('register') do
          expect(subject).to be_a(Integer)
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
          expect(subject).to eq(message)
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
          expect(subject).to eq(message)
        end
      end
    end
  end

  describe '#depositing_cash' do
    subject { register.depositing_cash(1.01) }

    context 'when shift is open' do
      it 'returns true' do
        VCR.use_cassette('depositing_cash') do
          expect(subject).to be_truthy
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('depositing_cash_error') do
          expect(subject).to eq(message)
        end
      end
    end
  end

  describe '#payment_cash' do
    subject { register.payment_cash(0.65) }

    context 'when shift is open' do
      it 'returns true' do
        VCR.use_cassette('payment_cash') do
          expect(subject).to be_truthy
        end
      end
    end

    context 'when shift is closed' do
      it 'returns error message' do
        message = 'Ошибка регистрации ( 61 : ККТ: Смена не открыта или смена превысила 24 часа – операция невозможна )'
        VCR.use_cassette('payment_cash_error') do
          expect(subject).to eq(message)
        end
      end
    end
  end

  describe '#x_report' do
    subject { register.x_report }

    it 'returns true' do
      VCR.use_cassette('x_report') do
        expect(subject).to be_truthy
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
          expect(subject).to eq(message)
        end
      end
    end
  end

  describe '#open_cash_drawer' do
    subject { register.open_cash_drawer }

    it 'returns true' do
      VCR.use_cassette('open_cash_drawer') do
        expect(subject).to be_truthy
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
end
