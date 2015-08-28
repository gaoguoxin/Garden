# encoding: utf-8
require 'uri'
require 'net/http'
require 'net/https'
require 'yaml'
require 'digest/md5'
require 'nokogiri'
require 'error_enum'
class Wechart
	@config = YAML.load_file("#{Rails.root.to_s}/config/wechart.yml")[Rails.env]

	def self.appid
		@config['appid']
	end

	def self.secret
		@config['secret']
	end
	
	def self.token
		@config['token']
	end

	def self.notify_url
		@config['notify_url']
	end


	def self.redirect_uri
		@config['redirect_uri']
	end

	def self.snsapi_base_redirect(url,state)
		"https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{self.appid}&redirect_uri=#{url}&response_type=code&scope=snsapi_base&state=#{state}#wechat_redirect"
	end

	def self.snsapi_userinfo_redirect(url,state)
		"https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{self.appid}&redirect_uri=#{url}&response_type=code&scope=snsapi_userinfo&state=#{state}#wechat_redirect"
	end	


	def self.global_access_token
		global_access_token = $redis.get('global_access_token')
		unless global_access_token.present?
			global_access_token = refresh_global_access_token
		end
		return global_access_token
	end


	def self.jsapi_ticket
		jsapi_ticket  = $redis.get('jsapi_ticket')
		unless jsapi_ticket.present?
		  jsapi_ticket = @config['jsapi_ticket']
		end
		return jsapi_ticket
	end

	# 获取全局access_token
	def self.refresh_global_access_token
		uri = URI("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{self.appid}&secret=#{self.secret}")
		res = Net::HTTP.new(uri.host, uri.port)
		res.use_ssl = true
		res.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = res.get(uri.request_uri)
		res = JSON.parse(res.body)	
		tok = res['access_token']
		$redis.set('global_access_token',tok)
		return tok
	end

	# 获取 jsapi_ticket
	def self.refresh_jsapi_ticket
		uri 	= URI("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{self.global_access_token}&type=jsapi")
		res 	= Net::HTTP.new(uri.host, uri.port)
		res.use_ssl = true
		res.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res 	= res.get(uri.request_uri)
		res 	= JSON.parse(res.body)
		unless res['errmsg'].include?('ok')
			refresh_global_access_token
			refresh_jsapi_ticket
		end
		ticket  = res['ticket']
		$redis.set('jsapi_ticket',ticket)
		return ticket
	end

	def self.batch_refresh_tasks
		refresh_global_access_token
		refresh_jsapi_ticket
	end


	# oauth 获取access_token和opennid
	def self.get_openid(code)
		uri     = URI("https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{self.appid}&secret=#{self.secret}&code=#{code}&grant_type=authorization_code")
		res 	= Net::HTTP.new(uri.host, uri.port)
		res.use_ssl = true
		res.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res 	= res.get(uri.request_uri)
		res 	= JSON.parse(res.body)
		return  res['openid']
	end

	# 根据用户openid获取该用户的基本信息
	def self.get_user_info(openid)
		uri   = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=#{self.global_access_token}&openid=#{openid}&lang=zh_CN"
		uri   = URI.parse(uri)
		res   = Net::HTTP.new(uri.host, uri.port)
		res.use_ssl = true
		res.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res   = res.get(uri.request_uri)
		res   = JSON.parse(res.body)
		return res
	end

	# 随机字符串
	def self.random_string(len=16)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		newpass = ""
		1.upto(len.to_i) { |i| newpass << chars[rand(chars.size-1)] }
		return newpass
	end

end