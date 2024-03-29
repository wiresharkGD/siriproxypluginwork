require 'cora'
require 'siri_objects'

#######
# This is a "hello world" style plugin. It simply intercepts the phrase "text siri proxy" and responds
# with a message about the proxy being up and running (along with a couple other core features). This 
# is good base code for other plugins.
# 
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::Example < SiriProxy::Plugin
  def initialize(config)
    #if you have custom configuration options, process them here!
  end

  listen_for /test siri proxy/i do
    say "Siri Proxy is up and running!" #say something to the user!
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate state change
  listen_for /siri proxy test state/i do
    set_state :some_state #set a state... this is useful when you want to change how you respond after certain conditions are met!
    say "I set the state, try saying 'confirm state change'"
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  listen_for /confirm state change/i, within_state: :some_state do #this only gets processed if you're within the :some_state state!
    say "State change works fine!"
    set_state nil #clear out the state!
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  #demonstrate asking a question
  listen_for /siri proxy test question/i do
    response = ask "Is this thing working?" #ask the user for something
    
    if(response =~ /yes/i) #process their response
      say "Great!" 
    else
      say "You could have just said 'yes'!"
    end
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /show them it working/i do
    say "Grant says Hello World to all of you ladies & gents!" #say something to the user!
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /machine track/i do
    say `./playing.py`
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /machine who are you/i do
      machine = `lsb_release -d`
      machine["Description:	"]= ""
      kernel = `uname -r`
      kernel["."]="-"
      kernel["."]="-"
      say "OS: " + machine + "," + "Kernel: " + kernel + "," + "Logged in as: " + `sudo -u grant whoami`
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /siri how are you feeling/i do
    say "Right now? I am feeling pretty exploited and exposed :("
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /machine launch/i do
    response = ask "Which application would you like to launch?"
    response = response.downcase
    if (response =~ /spotter five/i)
      new = ask "Did you mean Spotify?"
      new = new.downcase
      if (new =~ /yes/i)
       response = "spotify"
      elsif (new =~ /no/i)
       say "Ok, my bad"
      else
       say "Sorry I didn't understand: #{new}"
      end
    elsif (response =~ /google chrome/i)
      response = "google-chrome"
    elsif (response =~ /terminal/i)
      response = "gnome-terminal"
    elsif (response =~ /music player/i)
      response = "rhythmbox"
    end
    begin
    t = Thread.new { `sudo -u grant #{response}` }
    say "Attempting to launch: #{response}"
    #say "Attempting to launch: " + `#{response}`
    rescue
    say "Couldn't launch: #{response}"
    end
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
    listen_for /machine play/i do
    say `./play.py`
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

    listen_for /command /i do
    say `./commands.py`
    response = ask "What would you like to do?"
    if(response =~ /One/i) #process their response
      say `./playing.py`
    elsif(response =~ /Two/i)
      say `./play.py`
    elsif(response =~ /Three/i)
      say "Cant skip yet"
    elsif(response =~ /Four/i)
      say "Cant prev yet"
    elsif(response =~ /Five/i)
      machine = `lsb_release -d`
      machine["Description:	"]= ""
      kernel = `uname -r`
      kernel["."]="-"
      kernel["."]="-"
      say "OS: " + machine + "," + "Kernel: " + kernel + "," + "Logged in as: " + `sudo -u grant whoami`
    elsif(response =~ /Six/i)
      response = ask "Which application would you like to launch?"
      response = response.downcase
      if (response =~ /spotter five/i)
        new = ask "Did you mean Spotify?"
        new = new.downcase
        if (new =~ /yes/i)
         response = "spotify"
        elsif (new =~ /no/i)
         say "Ok, my bad"
        else
         say "Sorry I didn't understand: #{new}"
        end
      elsif (response =~ /google chrome/i)
        response = "google-chrome"
      elsif (response =~ /terminal/i)
        response = "gnome-terminal"
      elsif (response =~ /music player/i)
        response = "rhythmbox"
      end
      begin
      t = Thread.new { `sudo -u grant #{response}` }
      say "Attempting to launch: #{response}"
      #say "Attempting to launch: " + `#{response}`
      rescue
      say "Couldn't launch: #{response}"
      end
    else
      say "Please select a command. E.g. for command 1, please say '1'"
    end
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end

  #demonstrate capturing data from the user (e.x. "Siri proxy number 15")
  listen_for /siri proxy number ([0-9,]*[0-9])/i do |number|
    say "Detected number: #{number}"
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  #demonstrate injection of more complex objects without shortcut methods.
  listen_for /test map/i do
    add_views = SiriAddViews.new
    add_views.make_root(last_ref_id)
    map_snippet = SiriMapItemSnippet.new
    map_snippet.items << SiriMapItem.new
    utterance = SiriAssistantUtteranceView.new("Testing map injection!")
    add_views.views << utterance
    add_views.views << map_snippet
    
    #you can also do "send_object object, target: :guzzoni" in order to send an object to guzzoni
    send_object add_views #send_object takes a hash or a SiriObject object
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
end
