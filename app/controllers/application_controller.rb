class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :authenticate_openid,:except => [:notify]
  before_filter :get_wx_config_info  
  layout :resolve_layout
  helper_method :current_user
  has_mobile_fu
  

  def require_login
    redirect_to login_url unless current_user.present?
  end

  def current_user
    @current_user ||= User.where(id:cookies[:auth_key]).first if cookies[:auth_key].present?
  end

  def render_json(result)
    success = (result.is_a?(String) && result.start_with?('error_')) ? false : true 
    render json:{success:success,data:result}
  end

  def render_500
    raise '500 exception'
  end

  #以下为微信用

  def get_wx_config_info
    if(is_mobile_device?)
      @appid        = Wechart.appid
      @noncestr     = Wechart.random_string
      @jsapi_ticket = Wechart.jsapi_ticket
      @timestamp    = Time.now.to_i
      @url          = request.url
      string1       = "jsapi_ticket=#{@jsapi_ticket}&noncestr=#{@noncestr}&timestamp=#{@timestamp}&url=#{@url}"
      @signure      =  Digest::SHA1.hexdigest(string1) 
    end
  end

  def  authenticate_openid
    if(is_mobile_device?)
      if cookies[:open_auth].blank?
        code = params[:code]
        if code.nil?
          redirect_to Wechart.snsapi_base_redirect(request.url,request.url)
        else
          begin
            openid = Wechart.get_openid(code)
            set_openid_cookie(openid)
            #WechartUser.generate({"FromUserName" => openid}) # 授权就创建用户
          rescue Exception => e
              render_500
          end
        end
      end
    end
  end  

  def set_openid_cookie(openid)
      cookies[:open_auth] = {
        :value => openid,
        :expires => Rails.application.config.permanent_signed_in_months.months.from_now,
        :domain => :all
      }    
  end 

  def notify
    render :text => 'true'    
  end  




  private
  def resolve_layout
    mobile =  is_mobile_device? ? true : false
    if mobile 
      'mobile'
    else
      'pc'
    end
  end
end
