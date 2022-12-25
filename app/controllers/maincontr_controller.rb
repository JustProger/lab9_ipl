# frozen_string_literal: true

class MaincontrController < ApplicationController
  attr_reader :code, :err_msg, :ind_of_err_sym

  before_action :set_and_check_input_data, only: :show

  def input; end

  def show
    array = @input_sequence.split.map(&:to_i)
    number = @input_number_of_sequence_els.to_i
    if number == array.size
      enum = array.slice_when do |before, after|
        before_mod = is_square?(before)
        after_mod = is_square?(after)
        (!before_mod && after_mod) || (before_mod && !after_mod)
      end
    else
      redirect_to(root_path,
                  notice: [-2, 'Количество элементов массива не совпадает с тем, что была введено!!!', nil, nil])
    end

    @sequences = enum.to_a.select { |array| array.any? { |element| is_square?(element) } }
    @maxsequence = @sequences.max_by(&:size)
    @sequences_number = @sequences.size
  end

  private

  def is_square?(x)
    (Math.sqrt(x) % 1).zero?
  end

  def set_and_check_input_data
    @input_sequence = params[:query]
    @input_number_of_sequence_els = params[:number]
    check_str(@input_sequence)
    check_str(@input_number_of_sequence_els)
  end

  # проверка: строка должно состоять из натуральных чисел
  def check_str(str_to_check)
    return if str_to_check.is_a?(String) && str_to_check.match?(/^[\d ]+$/) && str_to_check.match?(/\d/)

    check_str_all(str_to_check)
  end

  def check_str_all(str_to_check)
    ptrn_list = [
      /[[:alpha:]]/,
      /[[:punct:]]/
    ]
    error_messages = [
      'Без букв!',
      'Без знаков пунктуации!'
    ]

    @code = nil
    @err_msg = nil
    @ind_of_err_sym = nil

    # Пояснение.
    # Код ошибки code:
    #   -2 --- количество элементов массива не совпадает с тем, что была введено (!!!проверка осуществляется в методе show)
    #   -1 --- неизвестная ошибка
    #   [значение > 0] --- остальные ошибки с пояснениями (индекс из массива error_messages + 1)

    # другие параметры:
    # ind_of_err_sym --- индекс символа в строке str_to_check, который мог вызвать ошибку

    if (err_ind = ptrn_list.find_index { |ptrn| @ind_of_err_sym = ptrn.match(str_to_check) })
      @code = err_ind + 1
      @err_msg = error_messages[err_ind]
      @ind_of_err_sym = @ind_of_err_sym.to_s
    else
      @code = -1
      @err_msg = 'Неизвестная ошибка! :( сам разбирайся... :('
      @ind_of_err_sym = nil
    end

    redirect_to(root_path, notice: [@code, @err_msg, @ind_of_err_sym, str_to_check]) unless code.zero?
  end
end
