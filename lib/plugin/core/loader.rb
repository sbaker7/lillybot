require 'logger'

module Plugin
  class Loader

    @@logger = Logger.new(STDOUT)

    def self.call(path)
      @@logger.info('Loading plugins...')
      plugin_files = File.join(path, 'plugins', '**', '__plugin__.rb')
      Dir.glob(plugin_files).each { |f| require_plugin f }
    end

  private

    def self.require_plugin(f)
      @@logger.debug("Loading plugin: #{f}")
      require_relative f
    rescue Exception => e
      puts "ERROR -: #{e.class.to_s}: #{e.message}"
    end

  end
end
