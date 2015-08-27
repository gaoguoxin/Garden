class Principal::GreenbeltsController < Principal::PrincipalController
  before_filter :set_greenbelt,only:[:edit,:update]
  def index
    @greenbelts = Greenbelt.principal_search
  end

  def new 
  end

  def edit
  end

  def update
    @greenbelt.update_attributes(params[:greenbelt])
  end

  private

  def set_greenbelt
    @greenbelt = Greenbelt.where(id:params[:id]).first
  end
end
