require './essentials/userlist/userlist.rb'

Trigger.new do |t|
  
  t.match { |info|
    info[:where].downcase == 'l'
  }
  
  t.act do |info|
    ULHandler::Lists[info[:room]].remove_by_name(info[:who])
  end

end