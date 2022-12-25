# frozen_string_literal: true

# MaincontrResult (не наследуемся от ApplicationRecord)
class MaincontrResult
	include ActiveModel::Model # примешиваем методы для модели из ActiveModel
	include ActiveModel::Validations # примешиваем методы для валидаций из ActiveModel

	attr_accessor :query_number, :query_sequence # создаем аттрибуты модели вручную, так как здесь нет связи с таблицей в БД

	validates :query_number, :query_sequence, presence: { message: 'не может быть пустым' } # проверка на обязательное наличие полей
	validates :query_number, format: { with: /\d/, message: 'должно быть натуральным числом' }

	@ptrn_list_and_error_messages = [
		{ :ptrn => /\A[\s\d]+\z/, :err_msg => 'состоит только из натуральных чисел, разделённых пробелами' }
	]
	
	@ptrn_list_and_error_messages.each do |el|
		validates :query_sequence, format: { with: el[:ptrn], message: el[:err_msg] }
	end

	# выполняем расчет сразу в модели, а не в контроллере
	def result
		array = query_sequence.split.map(&:to_i)
		number = query_number.to_i
		raise ArgumentError, 'Количество введённых чисел последовательности не соответствует тому, что было введено' if number != array.size
		enum = array.slice_when do |before, after|
				before_mod = is_square?(before)
				after_mod = is_square?(after)
				(!before_mod && after_mod) || (before_mod && !after_mod)
		end

		sequences = enum.to_a.select { |array| array.any? { |element| is_square?(element) } }
		{
			:sequences => sequences,
			:maxsequence => sequences.max_by(&:size),
			:sequences_number => sequences.size
		}
	end

	private

	def is_square?(x)
		(Math.sqrt(x) % 1).zero?
	end
end