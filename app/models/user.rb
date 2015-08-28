require 'encryption'
require 'error_enum'
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 50
  
  FEMALE  = 2
  MALE    = 1
  UNKNOWN = 0

  SUBSCRIBE = 1  #已关注该公众账号
  UNSUBSCRIBE = 0 #未关注该公众账号

  ADMIN      = 2  #系统管理员
  PRINCIAL   = 4  #绿地负责人
  SUPERVISOR = 8  #监督员
  CUSTOMER   = 16 #普通用户 
  field :name,type:String  
  field :mobile,type:String  
  field :email,type:String  
  field :password,type:String
  field :persona,type:Integer #角色
  field :openid,type:String #微信用户唯一id
  field :nick,type:String #微信昵称
  field :sex,type:Integer #微信性别
  field :country,type:String #微信显示国家
  field :province,type:String #微信显示省份
  field :city,type:String #微信显示城市
  field :language,type:String #微信显示语言
  field :headimgurl,type:String #微信头像url
  field :subscribe_time,type:Integer #关注时间
  field :subscribe,type:Integer #是否关注

  index({ name: 1 }, background: true )
  index({ nick: 1 }, background: true )
  index({ email: 1 }, background: true )
  index({ mobile: 1 }, background: true )
  index({ openid: 1 }, background: true )

  # has_one  :task

  #在导入绿地数据的时候创建绿地对应的负责人账号
  def self.create_principal(name,mobile=nil,email=nil)
    user = self.where(mobile:mobile).first 
    unless user.present?
      pwd = Encryption.encrypt_password('111111') #初始密码六个1
      self.create(name:name,email:email,mobile:mobile,persona:PRINCIAL,password:pwd) 
    end
  end

  #创建系统管理员账户
  def self.create_admin(name,mobile,email)
    user = self.where(mobile:mobile).first 
    unless user.present?
      pwd = Encryption.encrypt_password('111111') #初始密码六个1
      self.create(name:name,email:email,mobile:mobile,persona:ADMIN,password:pwd) 
    end    
  end

  #创建监督员(根据微信账户来更新)
  def self.create_supervisors

  end

  def self.add_from_wechart(openid)
    user = self.where(openid:openid).first
    Rails.logger.info "--------user:#{user.try(:id)}"
    unless user.present?
      user = self.create(openid:openid,persona:CUSTOMER)
      Rails.logger.info user.inspect
      Rails.logger.info '------------------------'
    end
  end

  #搜索监督员
  def self.search_supervisors(params)
    page  = params[:page] || 1
    users = self.wehre(persona:SUPERVISOR)
    if params[:name].present?
      users = users.wehre(name:/#{params[:name]}/)
    end
    if params[:mobile].present?
      users = users.wehre(mobile:params[:mobile]) 
    end
    if params[:email].present?
      users = users.wehre(email:params[:email])
    end
    if params[:nick].present?
      users = users.wehre(nick:/#{params[:nick]}/)
    end
    users = users.page(page)
  end

  def self.login(params)
    user = self.where(mobile:params[:mobile]).first
    return ErrorEnum::USER_NOT_EXIST unless user.present?
    pwd  = Encryption.encrypt_password(params[:password])
    return ErrorEnum::WRONG_PASSWORD if pwd != user.password
    return user
  end

  #是否是管理员
  def is_admin?
    return self.persona == ADMIN
  end
  #是否是绿地负责人
  def is_principal?
  	return self.persona == PRINCIAL
  end
end