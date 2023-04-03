class CardListsController < ApplicationController
  def index
    @card_lists = CardList.all
  end

  def new
    @card_list = CardList.new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
