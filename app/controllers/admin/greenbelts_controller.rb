class Admin::GreenbeltsController < Admin::AdminController
  before_action :set_greenbelt, only: [:show, :edit, :change, :destroy]
  def index
    @greenbelts = Greenbelt.admin_search(params[:page],params)
  end

  def new 
  end

  def edit
  end

  def change
    render_json @greenbelt.update_info(params['greenbelt'])

  end

  private

  def set_greenbelt
    @greenbelt = Greenbelt.where(id:params[:id]).first
  end

  def greenbelt_params
    params.require(:greenbelt).permit(:name)
  end

end
