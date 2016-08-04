module Plugin
  class Manager

    def self.define(name, &blk)
      name = name.to_sym

      raise "Plugin #{name} must define a block" unless block_given?
      raise "Plugin #{name} already defined" if @plugins.any? { |e| e.name == name }

      # create plugin object
      p = Plugin.new
      p.name = name

      # load the supplied block
      p.instance_eval(&blk)

      @plugins << p
    end

    def self.load_plugins(plugin_dir)
      Loader.call(plugin_dir)
      notify(:system_start)
    end

    def self.notify_shutdown
      notify(:system_stop)
    end

    def self.notify(event, *args)
      responses = []
      @plugins.select { |p| p.accepts?(event) }.each do |p|
        responses << notify_plugin(p, event, *args)
      end
      responses
    end

  private

    @plugins = []

    def self.notify_plugin(plugin, event, *args)
      plugin.notify(event, *args)
    rescue Exception => e
      Log.error "#{e.message}"
    end

  end

  class Plugin

    attr_accessor :name

    # should not be called directly, use PlugMan.define instead.
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
