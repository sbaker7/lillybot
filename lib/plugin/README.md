# Plugin Manager

### Manager example

```ruby
# load plugins
Plugin::Manager.load_plugins __dir__

# dispatching events
Plugin::Manager.notify :system_launched

# dispatching events with args
Plugin::Manager.notify :chat, 'ruby', 'hello world!'
```

### Plugin example

```ruby
class EchoPlugin < Plugin::Base

  # NOTE: plugins cannot have initialize methods

  def start
    puts 'ECHO: plugin has been started'
  end

  def chat(user, message)
    puts "ECHO: received chat from '#{user}' saying: '#{message}'"
  end

  def stop
    puts 'ECHO: plugin being stopped'
  end

end
```
