class CardsController < ApplicationController
  def new
    @card = Card.new
    @card_list = CardList.find(params[:card_list_id])
  end
end
