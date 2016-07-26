module Plugin
  class Loader

    def self.call(path)
      plugin_files = File.join(path, 'plugins', '**', '__plugin__.rb')
      Dir.glob(plugin_files).each { |f| require_plugin f }
    end

  private

    def self.require_plugin(f)
      require_relative f
    rescue Exception => e
      puts "ERROR -: #{e.class.to_s}: #{e.message}"
    end

  end
end
