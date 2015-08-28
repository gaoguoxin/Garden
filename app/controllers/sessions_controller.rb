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
  def wechart_api
    if request.get?
      Rails.logger.info '=========================='
      Rails.logger.info 'wechart_api get 请求。。。。。。'
      Rails.logger.info '=========================='
    else
      Rails.logger.info '=========================='
      Rails.logger.info 'wechart_api post 请求。。。。。。'
      Rails.logger.info '=========================='
    end
    check_msg_type
    result = verify
    render :text => params[:echostr] and return if result
    render :text => 'false'       
  end

  def check_msg_type
    msg_type = params[:xml][:MsgType]
    case msg_type
    when 'text'

    when 'image'

    when 'voice'

    when 'video'

    when 'shortvideo'

    when 'location'

    when 'link'

    when 'event'
      check_event
    end
  end

  def check_event
    event = params[:xml][:Event]
    case event
    when 'subscribe'
      #关注事件
      User.subscribe_from_wechart(params[:xml])
    when 'unsubscribe'
      #取消关注事件
      User.unsubscribe(params[:xml])
    end
  end

  #验证消息真实性
  def verify
    token     =  Wechart.token
    tmp_arr   =  []
    tmp_arr   << token
    tmp_arr   << params[:timestamp]
    tmp_arr   << params[:nonce]
    tmp_arr.sort!
    tmp_arr.join
    str       =  Digest::SHA1.hexdigest(tmp_arr.join)
    return true if str == params[:signature]
    return false  
  end

  def notify
    super
  end
end
