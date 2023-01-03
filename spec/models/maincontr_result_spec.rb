# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MaincontrResult, type: :model do
  # тестируем валидации
  describe 'validations' do
    # тестируем, что модель проверяет наличие параметров и выводит соответствующее сообщение
    it { should validate_presence_of(:query_number).with_message('не может быть пустым') }
    it { should validate_presence_of(:query_sequence).with_message('не может быть пустым') }

    # тестируем валидации, когда query_number и query_sequence не являются числами
    context 'when query_number or query_sequence are not digits' do
      it { should_not allow_value(Faker::Lorem.word).for(:query_number) }
      it { should_not allow_value(Faker::Lorem.word).for(:query_sequence) }
    end

    # тестируем валидации, когда query_number и query_sequence являются числами
    context 'when query_number or query_sequence are digits (or last is sequnce of numbers)' do
      let(:query_number) { Faker::Number.within(range: 10..20) }
      let(:query_sequence) do
        mas = []
        query_number.times { mas << Faker::Number.number(digits: 3) }
        mas.join(' ')
      end

      it { should allow_value(query_number).for(:query_number) }
      it { should allow_value(query_sequence).for(:query_sequence) }
    end
  end

  # тестируем работу метода result
  describe '#result' do
    let(:query_number) { 10 }
    let(:query_sequence) do
      mas = []
      query_number.times do
        temp = Faker::Number.number(digits: 1) + 1
        mas << temp**2 if temp > 3
      end
      mas.sort!
      mas.join(' ')
    end
    let(:params) { { query_number:, query_sequence: } }

    subject { described_class.new(params) }

    let(:result) do
      array = query_sequence.split.map(&:to_i)
      number = query_number.to_i
      enum = array.slice_when do |before, after|
        before_mod = (Math.sqrt(before) % 1).zero?
        after_mod = (Math.sqrt(after) % 1).zero?
        (!before_mod && after_mod) || (before_mod && !after_mod)
      end

      sequences = enum.to_a.select { |array| array.any? { |element| (Math.sqrt(element) % 1).zero? } }
      {
        sequences:,
        maxsequence: sequences.max_by(&:size),
        sequences_number: sequences.size
      }
    end

    it 'should sum values' do
      expect(subject.result).to eq(result)
    end
  end
end
