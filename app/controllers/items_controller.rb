class ItemsController < ApplicationController

  def index
    @items = Item.all
    @cart = Cart.new(session[:cart])
  end
end