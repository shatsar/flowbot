class PrinterHandler < BaseHandler
 
 def supports? (activity_type)
    return true
  end

  def handle(message)
	puts message.inspect
  end
end
