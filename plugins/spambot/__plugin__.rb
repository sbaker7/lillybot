require 'rufus-scheduler'

Lilly.plugin.define 'Spambot' do

  on(:system_start) do
    # do nothing?
    @scheduler = Rufus::Scheduler.new
    @job = nil
  end

  on(:system_stop) do
    # do nothing?
  end

  def turn_on()
    @job = @scheduler.every '10m', first_in: '0s' do "Go Astrious, go! Make sure to follow Astrious on twitter, @Astriousruns. You can play games and talk to me too! Try !commands"
  end

  def turn_off()
    @scheduler.unschedule(@job)
    "I can stop now? Being a sell out is tiring work..."
  end

  on(:spambot) do |user, message|
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
      "I don't know what '#{message}' means, #{user}"
    end
  end

end
