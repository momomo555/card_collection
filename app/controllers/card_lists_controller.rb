class CardListsController < ApplicationController
  def index
    @card_lists = CardList.all
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
  end

  def destroy
  end
end
