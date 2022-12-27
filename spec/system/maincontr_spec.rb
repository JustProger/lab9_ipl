# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Static content', type: :system do
  # автоматически создаем значения x и y
  let(:query_number) { 10 }
  let(:query_sequence) do
    i = 1
    mas = []
    query_number.times do
      mas << (i > 3 ? (i**2) : i)
      i += 1
    end
    mas.join(' ')
  end
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

  let(:query_number1) { 10 }
  let(:query_sequence1) { '2 3 5 6 7 8 10 11 12 13' }

  # сценарий успешного складывания x + y
  scenario 'when there is sequence in given data' do
    visit root_path # переходим на страницы ввода

    fill_in :query_number, with: query_number # заполняем поле с name="query_number"
    fill_in :query_sequence, with: query_sequence # заполняем поле с name="query_sequence"

    find('#calculate-btn').click # нажимаем на кнопку с id="calculate_btn"

    # ожидаем найти в контенере вывода правильное содержимое
    expect(find('#result-container')).to have_text(result[:sequences].to_s)
    expect(find('#result-container')).to have_text(result[:maxsequence].to_s)
    expect(find('#result-container')).to have_text(result[:sequences_number].to_s)
  end

  scenario 'when there is NO sequence in given data' do
    visit root_path # переходим на страницы ввода

    fill_in :query_number, with: query_number1 # заполняем поле с name="query_number"
    fill_in :query_sequence, with: query_sequence1 # заполняем поле с name="query_sequence"

    find('#calculate-btn').click # нажимаем на кнопку с id="calculate_btn"

    # ожидаем найти в контенере вывода правильное содержимое
    expect(find('#result-container')).to have_text('последовательностей не найдено')
  end

  # сценарий неправильного ввода формы
  scenario 'do not fill any values in form and click submit' do
    visit root_path # переходим на страницу ввода

    find('#calculate-btn').click # нажимаем на кнопку с id="calculate_btn"

    # ожидаем найти в контенере вывода содержимое с выводом всех ошибок модели
    MaincontrResult.new.errors.messages.each do |message|
      expect(find('#result-container')).to have_text(message)
    end
  end
end
