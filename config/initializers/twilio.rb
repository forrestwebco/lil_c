Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']
end

def send_twilio_sms to, msg
  client = Twilio::REST::Client.new
   client.messages.create({
     from: ENV['TWILIO_PHONE_NUMBER'],
     to: to,
     body: msg
   })
end
