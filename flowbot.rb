require 'rubygems'
require 'parseconfig'
require 'eventmachine'
require 'em-http'
require 'json'
require 'handlers/base_handler'
require 'handlers/deploy_handler'
require 'handlers/printer_handler'

$config_file_path = File.join(File.dirname(__FILE__), "flowbot.ini")

class FlowBot
  def initialize(token, organization, flow)
    @token = token
    @organization = organization
    @flow = flow

    @handlers = []
    @connection_options = {
      :connect_timeout => 6,
      :inactivity_timeout => 600
    }
  end

  def register_handler(new_handler)
    @handlers << new_handler
  end

  def run
    EventMachine.run do
      http = EM::HttpRequest.new("https://stream.flowdock.com/flows/#{@organization}/#{@flow}", @connection_options)
      s = http.get(:head => { 'Authorization' => [@token, ''], 'accept' => 'application/json'})
      s.errback  { puts 'Lost connection!' }

      buffer = ""
      s.stream do |chunk|
        buffer += chunk
        while line = buffer.slice!(/.+\r?\n/)
          handle_message JSON.parse(line)
        end
      end
    end
  end

  private

  def handle_message(msg)
    @handlers.each{
    |handler| handler.handle msg if handler.supports? msg['event']
    }
  end

end

config_file = ParseConfig.new($config_file_path)

fb = FlowBot.new(config_file['token'], config_file['organization'], config_file['flow'])

# decomment the following line to have see every received message
#fb.register_handler PrinterHandler.new
fb.register_handler DeployHandler.new
fb.run
