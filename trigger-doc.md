# Triggers

The basic structure of a trigger is this:

```ruby
Trigger.new do |t|
  t.match { |info|
    # checks
  }
  
  t.act { |info|
    # if those checks pass
  }
end
```


The info object is passed from the chat handler. It will be a hash that maps the following symbols
```ruby
{
  :who => ... # name of the user who chatted
  :where => ... # 'c' if it was in a main chat or 'pm' if it was in a PM
  :room => ... # the room the chat occured in (only relevant for 'c')
  :what => ... # the message the user sent
  :ws => ... # the websocket client object. (you won't need this in a match block)
}
  
```

Here's an example from a version of the stat calculator:

```ruby
t.match { |info|
  info[:what][0..3] == 'base' &&
  info[:what].scan(/[:\+\-\w]+/)
}
```

First, it checks if the message starts with `'base'`. If it does, then it returns a scan of each "flag" from the text. (for example, `base:40 +5` becomes `["base:40", "+5"]`) 

A match that would only respond to a certain person would look like this:

```ruby
t.match { |info|
  info[:what][0..3] == 'base' &&
  info[:who] == 'person' &&
  info[:what].scan(/[:\+\-\w]+/)
}
```

# Actions

Once the match has been performed and returns a value other than `false` or `nil`, this gets added to the info hash under the key `:result`

An example of this in action can be taken from a (shortened) version of the stat calculator's action:

```ruby
t.act do |info|
  # initialize all variables
  
  
  # loop through the list of flags
  info[:result].each do |term|
     # do stuff to variables
  end
  
  # calculate the result
 
  # format and send the message
  
  result = "your nice result"
  
  info[:respond].call(result) # invoking procs is different from invoking methods
end
```
Note the new key, `:respond`, and this is used to send a message back. If `info[:where] == 'pm'` then it will respond to the sender, and if `info[:where] == 'c'`, it will respond in `info[:room]`. **Important: this must be invoked with `info[:respond].call()` because it is a `Proc`, not a method.**

# Integrating with the Chat Handler

Ideally, every trigger (or logical group of triggers) should be in its own directory, and it should be named `<name>_trigger(s).rb` and it should look like:
```ruby
ChatHandler::TRIGGERS << Trigger.new do |t|
  t.match { |info|
    # stuff
  }
  
  t.act do |info|
    # more stuff
  end
end
```

Inside said directory, there should also be helper files for the trigger.

This file (and all of its helpers) should then be included at the bottom of `chathandler.rb`