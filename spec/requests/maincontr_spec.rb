# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maincontrs', type: :request do
  # Тестируем корневой маршрут
  describe 'GET /' do
    before { get root_path } # перед каждым тестом делать запрос

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'renders input template' do
      expect(response).to render_template(:input)
    end

    it 'responds with html' do
      expect(response.content_type).to match(%r{text/html})
    end
  end

  # Тестируем маршрут вывода результата
  describe 'GET /result' do
    # Сценарий, когда параметры неправильные
    context 'when params are invalid' do
      # перед каждым тестом делать запрос (xhr: true - значит асинхронно, чтобы работал turbo)

      let(:query_number) { @var_query_number = Faker::Number.within(range: 10..20) }
      let(:query_sequence) do
        mas = []
        @var_query_number.times { mas << Faker::Number.number(digits: 3) }
        mas.join(Faker::Alphanumeric.alpha(number: 1)) # намеренно соединяем числа в строку при помощи рандомной буквы
      end

      before { post result_path, params: { query_number:, query_sequence: }, xhr: true }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders result templates' do
        expect(response).to render_template(:result)
        expect(response).to render_template(:_result_message)
      end

      it 'responds with turbo stream' do
        expect(response.content_type).to match(%r{text/vnd.turbo-stream.html})
      end

      it 'assigns invalid model object' do
        expect(@controller.view_assigns['maincontr'].valid?).to be false
        # @controller.view_assigns['maincontr']
      end
    end

    # Сценарий, когда парамаетры правильные
    context 'when params are ok' do
      # создаем случайные значения
      let(:query_number) { @var_query_number = Faker::Number.number(digits: 2) }
      let(:query_sequence) do
        mas = []
        @var_query_number.times { mas << Faker::Number.number(digits: 3) }
        mas.join(' ')
      end

      # перед каждым тестом делать запрос (params - параметры запроса, xhr: true - выполнить асинхронно, чтобы работал turbo)
      before { post result_path, params: { query_number:, query_sequence: }, xhr: true }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders result templates' do
        expect(response).to render_template(:result)
        expect(response).to render_template(:_result_message)
      end

      it 'responds with turbo stream' do
        expect(response.content_type).to match(%r{text/vnd.turbo-stream.html})
      end

      it 'assigns valid model object' do
        expect(@controller.view_assigns['maincontr'].valid?).to be true
      end
    end
  end
end
