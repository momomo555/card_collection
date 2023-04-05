class CardsController < ApplicationController
  def index
    @card_list = CardList.find(params[:card_list_id])
    @cards = Card.where(card_list_id: @card_list.id)
  end
  
  def new
    @card = Card.new
    @card_list = CardList.find(params[:card_list_id])
  end

  def create
    @card = Card.new(params.require(:card).permit(:name, :rarity, :number, :memo, :owned, :favorite, :card_list_id))
    @card_list = CardList.find(params[:card_list_id])
    if @card.save
      flash[:notice] = "カードリストを作成しました"
      redirect_to :card_lists
    else
      render "new"
    end
  end

  def show
    @card = Card.find(params[:id])
  end
end
