# Plugin Manager

### Manager example

```ruby
# load plugins
Plugin::Manager.load_plugins __dir__

# dispatching events
Plugin::Manager.notify(:start)

# dispatching events with args
Plugin::Manager.notify(:chat, 'ruby', 'hello world!')
```

### Plugin example

```ruby
Plugin::Manager.define 'Echo' do

  on(:start) do
    puts 'ECHOPLUGIN: plugin has been started'
  end

  # events can accept arguments
  on(:chat) do |user, message|
    puts "ECHOPLUGIN: received chat from '#{user}' saying: '#{message}'"
  end

  # events can have aliases
  on(:stop, :halt) do
    puts 'ECHOPLUGIN: plugin being stopped'
  end

end
```
