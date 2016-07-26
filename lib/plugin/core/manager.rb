module Plugin
  class Manager
    @@plugins = []

    def self.load_plugins(path)
      Loader.call(path)
      notify(:start)
    end

    def self.unload_plugins
      notify(:stop)
      @@plugins = []
    end

    def self.notify(event, *args)
      @@plugins.select { |p| p.respond_to?(event) }.each do |p|
        notify_plugin(p, event, *args)
      end
      true
    end

    # Called from Plugin::Base when inherited
    def self.register_plugin(plugin)
      @@plugins.push(plugin.new)
    end

  private

    def self.notify_plugin(plugin, event, *args)
      plugin.send(event, *args)
    rescue Exception => e
      puts "ERROR -: #{e.message}"
    end

  end
end
