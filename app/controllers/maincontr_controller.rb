# frozen_string_literal: true

class MaincontrController < ApplicationController
  def input; end

  def result
    @maincontr = MaincontrResult.new(maincontr_params)
    @result = @maincontr.result
  end

  private

  def maincontr_params
    params.permit(:query_number, :query_sequence) # явно задаем, какие параметры разрешены
  end

  def is_square?(x)
    (Math.sqrt(x) % 1).zero?
  end
end
