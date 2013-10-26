# Primary Author: Jonathan Allen (jallen01)

# Controls adding/removing items in a group. All actions only return json.
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, except: [:new, :create]
  before_action :check_member

  def new
    group = params[:group_id]
    @item = group.items.new
  end

  def edit
  end

  def create
    group = params[:group_id]
    @item = group.edit_item_by_name(item_params[:name], item_params[:cost])

    respond_to do |format|
      if @item.save
        format.json { render status: :created }
      else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update(item_params)
        format.json { render status: :ok }
      else
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy
    respond_to do |format|
      format.json { render status: :ok }
    end
  end

  private

    def set_item
      @item = Item.find(params[:id])

      # If item id is invalid, render 404.
      unless @group
        format.json { render status: :not_found }
      end 
    end

    # Sanitize params.
    def item_params
      params.require(:item).permit(:name)
    end

    # If current user is not in item's group, render 403.
    def check_permission
      group = params[:group_id]
      unless group.include_user?(current_user)
        respond_to do |format|
          format.json { render status: :forbidden }
        end
      end
    end
end
