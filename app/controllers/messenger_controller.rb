class MessengerController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :recipient

  def hook
    mode = params['hub.mode']
    verify_token = params['hub.verify_token']
    challenge = params['hub.challenge']

    if mode.eql? 'subscribe' and verify_token.eql? ENV["VERIFY_TOKEN"]
      #For FB check
      render json: challenge
    else
      render plain: 'Error!'
    end
  end

  def recipient
    json = JSON.parse(request.body.read)
    return render plain: 'Error!' unless json['object'] == 'page'

    json = JSON.parse(request.body.read)
    return error_response() unless json['object'] == 'page'

    json['entry'].each do |entry|
      entry['messaging'].each do |message|
        sender_id = message['sender']['id']
        if message['message']['text'].present?
          msg = message['message']['text'].downcase
          send_msg(msg: msg, sender_id: sender_id)
        end
      end
    end
    render plain: 'Success!'
  end

  private

  def msg_process(msg:, sender_id:)
    return "Vui lòng nhập đúng mã số sinh viên mà bạn đã đăng ký trên hệ thống Schedude" if msg.length > 10

    if msg.eql? 'stop'
      student = Student.find_by recipient_id: msg
      if student.nil?
        'Bạn chưa kích hoạt tính năng nhắc lịch của Schedude!'
      else
        student.update_attribute :recipient_id, ""
        'Đã hủy thành công tính năng nhắc lịch của Schedude!'
      end
    else
      student = Student.find_by student_id: msg
      if student.nil?
        'Bạn chưa đăng ký lịch trên hệ thống Schedude!'
      elsif not student.recipient_id.blank?
        'Bạn chưa đã kích hoạt chức năng nhắc lịch trên hệ thống Schedude rồi! ' \
        'Để ngừng nhắc lịch, hãy nhập stop'
      else
        student.update_attribute :recipient_id, sender_id
        'Kích hoạt chức năng nhắc lịch thành công! Để dừng nhắc lịch, hãy nhập stop!'
      end
    end
  end

  def send_msg(msg:, sender_id:)
    msg_to_send = msg_process(msg: msg, sender_id: sender_id)

    Messenger.send_msg(
      sender_id,
      { text: msg_to_send }
    )
  end
end
