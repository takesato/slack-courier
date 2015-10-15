require 'httmultiparty'
require 'faye/websocket'
require 'eventmachine'
require 'open-uri'
require 'tempfile'
require 'yaml'
require 'uri'

module Slack
  module Courier
    class Client
      include HTTMultiParty

      base_uri 'https://slack.com/api'

      def initialize(token)
        @initialize_time = Time.now.to_i
        @token = token
        @url = self.class.post('/rtm.start', body: {token: @token})['url']
        @callbacks ||= {}
      end

      def start
        EM.run do
          ws = Faye::WebSocket::Client.new(@url)

          ws.on :open do |event|
          end

          ws.on :message do |event|
            data = JSON.parse(event.data)
            if data['type'] == 'message' && data['subtype'].nil? && !data['text'].nil?
              next if data['ts'].to_i <= @initialize_time
              channel = data['channel']
              URI.extract(data['text'], ["http", "https"]).each do |url|
                next unless data['text'] =~ URL_REGEXP
                response = upload(channel, url)
                send_message channel, response['file']['url'] if response['ok'] == true
              end
            end
          end

          ws.on :close do |event|
            EM.stop
          end
        end
      end

      def upload(channel, url)
        temp = Tempfile.new('temp')
        temp.binmode
        open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |data|
          temp.write(data.read)
        end
        message = {
          token: @token,
          channel: channel,
          file: File.new(temp.path),
          filename: File.basename(url),
        }
        self.class.post('/files.upload', body: message)
      end

      def send_message(channel, text)
        message = {
          token: @token,
          username: BOT_NAME,
          channel: channel,
          text: text,
        }
        self.class.post('/chat.postMessage', body: message)
      end
    end
  end
end
