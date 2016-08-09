module Plugin
  class SimpleLoader

    def call(path)
      Lilly.log.info 'Loading plugins...'
      plugin_files = File.join(path, 'plugins', '**', '__plugin__.rb')
      Dir.glob(plugin_files).each { |f| require_plugin f }
    end

  private

    def require_plugin(f)
      Lilly.log.debug "Loading plugin: #{f}"
      require_relative f
    rescue Exception => e
      Lilly.log.error "#{e.message}"
    end

  end
end
