class Messenger
  def self.send_msg(recipient_id, message)
    return nil if recipient_id.length < 1 || message.length < 1

    Excon.post(
      "https://graph.facebook.com/v9.0/me/messages?access_token=#{ENV["FB_ACCESS_TOKEN"]}",
      headers: {
        'Content-Type' => 'application/json'
      },
      body: {
        recipient: {
          id: recipient_id
        },
        message: message
      }.to_json
    )
    puts "Message sent!"
  end
end