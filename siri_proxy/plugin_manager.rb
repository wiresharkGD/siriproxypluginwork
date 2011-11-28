require 'cora'
require 'pp'
require 'rainbow'

class SiriProxy::PluginManager < Cora
  attr_accessor :plugins, :iphone_conn, :guzzoni_conn
  
  def initialize()
    load_plugins()
  end
  
  def load_plugins()
    @plugins = []
    if APP_CONFIG.plugins
      APP_CONFIG.plugins.each do |pluginConfig|
          if pluginConfig.is_a? String
            className = pluginConfig
            requireName = "siriproxy-#{className.downcase}"
          else
            className = pluginConfig['name']
            requireName = pluginConfig['require'] || "siriproxy-#{className.downcase}"
          end
          require requireName
          plugin = SiriProxy::Plugin.const_get(className).new(pluginConfig)
          plugin.manager = self
          @plugins << plugin
      end
    end
    log "Plugins laoded: #{@plugins}"
  end

  def process(text)
    result = super(text)
    self.guzzoni_conn.block_rest_of_session if result
    return result
  end
  
  def send_request_complete_to_iphone
    log "Sending Request Completed"
    object = generate_request_completed(self.guzzoni_conn.last_ref_id)
    self.guzzoni_conn.inject_object_to_output_stream(object)
  end
  
  def respond(text, options={})
    self.guzzoni_conn.inject_object_to_output_stream(generate_siri_utterance(self.guzzoni_conn.last_ref_id, text, text, options[:prompt_for_response] == true))
  end
  
  def no_matches
    return false
  end
  
  def log(text)
    if text.include? "Say:"
       msg = "#{text}"
       msg["Say:"]= ""
       msg[" "]= ""
       puts "Server_Response:\n" + msg.color(:blue) + "\n" if LOG_LEVEL >= 1
    elsif text.include? "Ask:"
       msg = "#{text}"
       msg["Ask:"]= ""
       msg[" "]= ""
       puts "Server_ASK:\n" + msg.color(:green) + "\n" if LOG_LEVEL >= 1
    elsif text.include? "Processing '"
       msg = "#{text}"
       msg["'"]= ""
       msg["Processing"]= ""
       msg["'"]= ""
       msg[" "]= ""
       puts "Client:\n" + msg.color(:white) + "\n\n" if LOG_LEVEL >= 1
    else
       #puts "[Info - Plugin Manager] #{text}" if LOG_LEVEL >= 1
    end
  end
end
