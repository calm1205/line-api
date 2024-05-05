require 'net/http'
require 'uri'

class LineController < ApplicationController

  before_action :line_params, only: [:post]

  def index
    response = {
      status: :success
    }

    render json: response
  end

  def post
    uri = URI.parse("https://api.line.me/v2/bot/message/reply")
    http = Net::HTTP.new(uri.host, uri.port)

    # もしHTTPSを使用する場合は、以下のようにSSLを有効にします
    http.use_ssl = true

    # リクエストを作成
    request = Net::HTTP::Post.new(uri.request_uri)

    request['Content-Type'] = 'application/json'
    # Bearerトークンをセット
    token = "BbaYRBzgFnbOiIUUZxyPdIFuiAfQLsxKdHYV414RLUICzuG6Pg33pVJIqeeU32Y8zMvvOevhlP8822iikjim4nH5T0e1B+OToaTRO4FBNX1BpCsOuqI5rue3yqaiu2h2g9ThKPI30fN8InqytEcR2gdB04t89/1O/w1cDnyilFU="
    request['Authorization'] = "Bearer #{token}"
    retry_token = line_params[0][:replyToken]
    response = {
      replyToken: retry_token,
      messages: [
        {
          type: "text",
          text: "Autoreply: Hello, World!"
        },
      ] 
    }
    request.body = response.to_json

    # リクエストを送信
    response = http.request(request)
    puts response.body

    render json: response
  end

  private

  def line_params
    params[:line][:events]
  end
end