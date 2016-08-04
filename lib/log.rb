require 'logger'

class Log

  def self.info(message)
    @@logger.info(message)
  end

  def self.debug(message)
    @@logger.debug(message)
  end

  def self.error(message)
    @@logger.error(message)
  end

private

  @@logger = Logger.new(STDOUT)

end
