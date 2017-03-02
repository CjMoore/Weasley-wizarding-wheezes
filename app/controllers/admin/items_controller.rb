class Admin::ItemsController < Admin::BaseController
  include ActionView::Helpers::TextHelper

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path
     flash[:success] = "Mischief managed."
    else
      flash[:failure] = "Please make sure all fields are filled out."
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(image_tag: nil) if item_params[:image]
    if @item.update_attributes(item_params)
      @item.update_attributes(item_status: params[:item][:item_status])
      flash[:success] = "Mischief managed: #{@item.title} has been updated!"
      redirect_to admin_items_path
    else
      flash[:failure] = "Uh-oh, not quite!"
      render :update
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  private
  def item_params
    params.require(:item).permit(:title,
                                :description,
                                :price,
                                :category_id,
                                :tag_list,
                                :image,
                                :status
                                )
  end
end
