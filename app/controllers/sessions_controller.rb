class SessionsController < ApplicationController
  before_filter :require_login, only:[:re_dispatch]
  def new
    redirect_to root_url if current_user
  end

  def create
    user = User.login(params)
    if user && user.is_a?(User)
      cookies[:auth_key] = {
        :value => user.id.to_s,
        :expires => Rails.application.config.permanent_signed_in_months.months.from_now,
        :domain => :all
      }
    end
    render_json(user) 
  end

  def re_dispatch
    redirect_to '/admin/greenbelts'  if current_user.is_admin?
    redirect_to '/principal/greenbelts'  if current_user.is_principal?
  end


  def destroy
    cookies.delete(:auth_key, :domain => :all)
    redirect_to login_url
  end

  # 微信用
  def notify
    super
  end
end
