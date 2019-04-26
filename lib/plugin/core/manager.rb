module Plugin
  class Manager

    def initialize(loader = SimpleLoader.new)
      @loader = loader
      @plugins = []
    end

    def define(name, &blk)
      name = name.to_sym
      Lilly.log.debug "Defining plugin #{name.inspect}"

      raise "Plugin #{name} must define a block" unless block_given?
      raise "Plugin #{name} already defined" if @plugins.any? { |e| e.name == name }

      # create plugin object
      p = Plugin.new
      p.name = name

      # load the supplied block
      p.instance_eval(&blk)

      @plugins << p
    end

    def accepts(name)
      @plugins.any? { |p| p.accepts?(name) }
    end

    def load_plugins(plugin_dir)
      @loader.call(plugin_dir)
      notify(:system_start)
    end

    def notify_shutdown
      notify(:system_stop)
    end

    def notify(event, *args)
      responses = []
      @plugins.select { |p| p.accepts?(event) }.each do |p|
        responses << notify_plugin_internal(p, event, *args)
      end
      responses
    end

    def notify_plugin(plugin, event, *args)
      responses = []
      name = plugin.to_sym
      @plugins.select { |p| p.name == name }.each do |p|
        responses << notify_plugin_internal(p, event, *args)
      end
      responses
    end

  private

    def notify_plugin_internal(plugin, event, *args)
      plugin.notify(event, *args)
    rescue Exception => e
      Lilly.log.error "Error notifying #{plugin.name}: #{e.message}"
      Lilly.log.debug e.backtrace
    end

  end

  class Plugin

    attr_accessor :name

    # should not be called directly, use the manager's define method instead.
    def initialize()
      @callbacks = {}
    end

    def on(*callbacks, &blk)
      callbacks.each { |c|
        (@callbacks[c.to_sym] ||= []) << blk
      }
    end

    def notify(event, *args)
      responses = []
      (@callbacks[event.to_sym] || []).each { |blk|
        responses << blk.call(*args)
      }
      responses
    end

    def accepts?(event)
      @callbacks.key?(event.to_sym)
    end

  private

    attr_accessor :callbacks

  end
end
