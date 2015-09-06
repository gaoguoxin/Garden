class GreenbeltsController < ApplicationController

  def index 
  end

  def nearby
  	res = Greenbelt.nearby([params[:lng].to_f,params[:lat].to_f])
  	render_json res
  end
  
end
