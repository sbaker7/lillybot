require 'rufus-scheduler'

Lilly.plugin.define 'Spambot' do

  on(:system_start) do
    puts "SPAMBOT DEBUG: initialising spambot"
    @scheduler = Rufus::Scheduler.new
    @job = nil
  end

  on(:system_stop) do
    # do nothing?
  end

  def turn_on()
    puts "SPAMBOT DEBUG: turning on"
    message = "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"

    @job = @scheduler.every '10m', first_in: '0s' do notify(:scheduled_task, message)
  end

  def turn_off()
    puts "SPAMBOT DEBUG: turning off"
    @scheduler.unschedule(@job)
    message = "I can stop now? Being a sell out is tiring work..."
  end

  on(:spambot) do |user, message|
    puts "SPAMBOT DEBUG: #{user} asked #{message}"
    if message =~ /on/i
      if user == "astrious" || user == "dragnflier"
        responses << turn_on()
      else
        responses << "You don't have permission to do that, #{user}"
      end
    elsif message =~ /off/i
      if user == "astrious" || user == "dragnflier"
        responses << turn_off()
      else
        responses << "You don't have permission to do that, #{user}"
      end
    else
      responses << "I don't know what '#{message}' means, #{user}"
    end

    responses
  end

end
