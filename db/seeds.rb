admins = [
  {name:'naitnix',mobile:'15210427877',email:'naitnix@126.com'},
  {name:'boswellgao',mobile:'13681457954',email:'boswellgao@gmail.com'}
]

admins.each do |admin|
  User.create_admin(admin[:name],admin[:mobile],admin[:email])
end