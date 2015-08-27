class Greenbelt
  include Mongoid::Document
  include Mongoid::Timestamps

  paginates_per 50

  ROAD      = 0 #道路绿地
  COMMUNITY = 1 #小区绿地
  LAKE      = 2 #河湖绿地
  PARK      = 3 #公园绿地 

  ENABLE    = 1 #可用
  DISABLE   = 0 #不可用


  field :code,type:Integer #绿地编码
  field :name,type:String #绿地名称
  field :address,type:String #绿地详细地址(经过地图得出)
  field :position,type:Array #经纬度
  field :polygons,type:Array #多边形拐点坐标
  field :type,type:Integer,default:ROAD #绿地类型(道路、小区、河湖、公园)	
  field :description,type:String #绿地范围描述信息
  field :acreage,type:BigDecimal #绿地面积
  field :plants,type:String #绿植
  field :organization,type:String #责任单位或组织
  field :connects,type:Array #联系人及联系方式[{name:'xx',mobile:'xx',email:'xx'}]
  field :status,type:Integer,default:ENABLE

  index({position: '2d'}, background: true)

  after_create :generate_principal

  default_scope -> {where(status:ENABLE).order_by(created_at:'asc')}

  # 导入excel文件到数据库	
  def self.import_data(file_path)
    book   = SimpleSpreadsheet::Workbook.read(file_path)
    book.selected_sheet = book.sheets.first
    hash = Hash.new(0)
    book.first_row.upto(book.last_row) do |line|
      hash[:code] = book.cell(line, 1).to_i
      hash[:name] = book.cell(line, 2)
      hash[:type] = convert_to_type(book.cell(line, 3))
      hash[:description] = book.cell(line, 4)
      hash[:acreage] = book.cell(line, 5)
      hash[:plants] = book.cell(line, 6)
      hash[:organization] = book.cell(line, 7)
      hash[:connects] = generate_connects(book,line)
      self.create(hash)
    end
  end

  def self.convert_to_type(str)
  	return ROAD if str.match(/道路/)
  	return COMMUNITY if str.match(/小区/)
  	return LAKE if str.match(/河湖/)
  	return PARK if str.match(/公园/)
  end

  def self.generate_connects(book,line)
  	arr   = []
    name1 = book.cell(line, 8)
    mobi1 = book.cell(line, 9).to_i
    emai1 = book.cell(line, 10)
    arr.push({name:name1,mobile:mobi1,email:emai1}) if name1 && mobi1 && emai1
    name2 = book.cell(line, 11)
    mobi2 = book.cell(line, 12).to_i
    emai2 = book.cell(line, 13)
    arr.push({name:name2,mobile:mobi2,email:emai2}) if name2 && mobi2 && emai2
    return arr
  end

  def self.admin_search(page=1,name=nil)
  	greenbelts = self.all
  	if page.present?
  	  greenbelts = greenbelts.where(name:/#{name}/)
  	end
    greenbelts.page(page)
  end

  def self.principal_search
    self.page(1)
  end

  #创建责任人
  def generate_principal
    self.connects.each do |connect|
      User.create_principal(connect[:name],connect[:mobile],connect[:email])
    end
  end

  def gtype
    return '道路绿地' if type == ROAD
    return '小区绿地' if type == COMMUNITY
    return '河湖绿地' if type == LAKE
    return '公园绿地' if type == PARK    
  end

end