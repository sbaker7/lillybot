# Plugin Manager

### Manager example

```ruby
# create plugin manager
manager = Plugin::Manager.new

# load plugins
manager.load_plugins __dir__

# dispatching events
manager.notify(:start)

# dispatching events with args
manager.notify(:chat, 'ruby', 'hello world!')

# events can also be strings, this will be converted to a symbol
manager.notify('123lookatme')
```

**Note:** Instances of the plugin manager will need to be accessible statically/globally so that plugins may be defined.

### Plugin example

```ruby
manager.define 'Echo' do

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

  # events can have numbers at the start
  on('123lookatme'.to_sym) do
    puts 'ECHOPLUGIN: ruby is awesome'
  end

end
```
