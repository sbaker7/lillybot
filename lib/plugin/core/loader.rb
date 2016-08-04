module Plugin
  class Loader

    def self.call(path)
      Log.info 'Loading plugins...'
      plugin_files = File.join(path, 'plugins', '**', '__plugin__.rb')
      Dir.glob(plugin_files).each { |f| require_plugin f }
    end

  private

    def self.require_plugin(f)
      Log.debug "Loading plugin: #{f}"
      require_relative f
    rescue Exception => e
      Log.error "#{e.message}"
    end

  end
end
