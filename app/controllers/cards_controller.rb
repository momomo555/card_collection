class CardsController < ApplicationController
  include ApplicationHelper
  def index
    @card_list = CardList.find(params[:card_list_id])
    # rubocop:disable Airbnb/RiskyActiverecordInvocation
    @cards = Card.where(card_list_id: @card_list.id).page(params[:page]).order(sort_column + ' ' + sort_direction)
    # rubocop:enable Airbnb/RiskyActiverecordInvocation
  end

  def new
    @card = Card.new
    @card_list = CardList.find(params[:card_list_id])
  end

  def create
    @card = Card.new(params.require(:card).permit(:name, :rarity, :number, :memo, :owned, :favorite, :card_list_id, :image))
    @card_list = CardList.find(params[:card_list_id])
    if @card.save
      flash[:notice] = "カードを登録しました。"
      redirect_to card_list_cards_path(@card_list.id)
    else
      render "new", status: :unprocessable_entity
    end
  end

  def show
    @card = Card.find(params[:id])
    @card_list = CardList.find(params[:card_list_id])
  end

  def edit
    @card = Card.find(params[:id])
    @card_list = CardList.find(params[:card_list_id])
  end

  def update
    @card = Card.find(params[:id])
    @card_list = CardList.find(params[:card_list_id])
    if @card.update(params.require(:card).permit(:name, :rarity, :number, :memo, :owned, :favorite, :card_list_id, :image))
      flash[:notice] = "カード情報を更新しました。"
      redirect_to card_list_cards_path(@card_list.id)
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    flash[:notice] = "カードを削除しました。"
    redirect_to card_list_cards_path(params[:card_list_id])
  end

  def search
    @cards = Card.where(card_list_id: current_user.card_lists.ids).where("name LIKE?", "%#{params[:word]}%")
    @card_count = @cards.count
    # rubocop:disable Airbnb/RiskyActiverecordInvocation
    @cards = @cards.page(params[:page]).order(sort_column + ' ' + sort_direction).includes(:card_list)
    # rubocop:enable Airbnb/RiskyActiverecordInvocation
  end

  private

  def sort_column
    if Card.column_names.include?(params[:column])
      params[:column]
    elsif CardList.column_names.include?(params[:column])
      "card_lists.#{params[:column]}"
    else
      "name"
    end
  end
end
