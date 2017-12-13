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
end
