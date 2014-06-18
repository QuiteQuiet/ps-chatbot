module Userlist
  extend self
  
  def init
    @@users = []
  end
  
  def list
    return @@users
  end
  
  def add_user name
    @@users << User.new(name)
  end

  def remove_by_name name
    @@users.delete_if { |user| user.name == CBUtils.condense_name(name) }
  end
  
  def get_user name
    @@users.find { |user| user.name == CBUtils.condense_name(name) }
  end
  
  def get_user_group name
    get_user(name).group
  end
  

end

class User
  attr_reader :name, :group, :previous_names
  
  def initialize name, previous = []
    setname(name)
    previous_names = previous
  end
  
  def setname name
    @group = name[0]
    @name = CBUtils.condense_name(name[1..-1])
  end
  
  def rename newname
    previous_names << @name
    setname(newname)
  end
    
end

Userlist.init