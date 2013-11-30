require "./bread/battles.rb"

$chat << Trigger.new do |t|
  t[:lastused] = Time.now - 10
  t[:cooldown] = 10
  t[:lastbattle] = nil
  
  t.match { |info| 
    info[:where] == 'c'
  }
  
  t.act do |info|
    t[:lastused] + t[:cooldown] < Time.now or next
    
    lastbattle = Battles.get_battles.last
    if t[:lastbattle] != lastbattle
      t[:lastbattle] = lastbattle
      info[:respond].call("New battle posted in bread: #{lastbattle}")
    end
    
  end
end