class CardListsController < ApplicationController
  include ApplicationHelper

  def index
    # rubocop:disable Airbnb/RiskyActiverecordInvocation
    @card_lists = current_user.card_lists.page(params[:page]).order(sort_column + ' ' + sort_direction)
    # rubocop:enable Airbnb/RiskyActiverecordInvocation
  end

  def new
    @card_list = CardList.new
  end

  def create
    @card_list = CardList.new(params.require(:card_list).permit(:title, :card_type, :user_id))
    if @card_list.save
      flash[:notice] = "カードリストを作成しました"
      redirect_to :card_lists
    else
      render "new"
    end
  end

  def show
  end

  def edit
    @card_list = CardList.find(params[:id])
  end

  def update
    @card_list = CardList.find(params[:id])
    if @card_list.update(params.require(:card_list).permit(:title, :card_type))
      flash[:notice] = "カードリストを更新しました"
      redirect_to :card_lists
    else
      render "edit"
    end
  end

  def destroy
    @card_list = CardList.find(params[:id])
    @card_list.destroy
    flash[:notice] = "カードリストを削除しました"
    redirect_to :card_lists
  end

  private

  def sort_column
    CardList.column_names.include?(params[:column]) ? params[:column] : "title"
  end
end
