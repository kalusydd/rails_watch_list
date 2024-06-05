class ListsController < ApplicationController
  before_action :set_list, only: [:show, :destroy]

  def index
    @lists = List.all
  end

  def show
    @bookmark = Bookmark.new
    # @review = Review.new(list: @list)
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      redirect_to list_path(@list), notice: 'List was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @list.user == current_user
      @list.destroy
      redirect_to root_path, status: :see_other
    else
      redirect_to list_path(@list)
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end
end
