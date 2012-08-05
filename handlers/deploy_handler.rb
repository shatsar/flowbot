class DeployHandler < BaseHandler
  PLAYER = "afplay"
  def supports? (activity_type)
    return activity_type == "line"
  end

  def handle(message)
    if message["content"] == "deploying"
      fork do
        exec "#{PLAYER} " + File.join(File.dirname(__FILE__), "nuclearalarm.wav")
      end
    end
  end
end