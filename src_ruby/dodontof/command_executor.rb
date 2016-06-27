# -*- coding: utf-8 -*-

require 'dodontof/msgpack_loader'

require 'dodontof/rack_response_generator'
require 'dodontof/response'
require 'dodontof/message'
require 'dodontof/command/client_commands/all'
require 'dodontof/command/web_if_commands/all'

module DodontoF
  # コマンド実行処理のモジュール
  module CommandExecutor
    module_function

    # HTTP リクエスト解析結果を元にコマンドの実行を試み、
    #   Rack::Response 生成器を得る
    # @param [HttpRequestParseResult] httpRequestParseResult
    #   HTTP リクエスト解析結果
    # @param [Class] serverClass サーバーのクラス
    # @param [Class] saveDirInfoClass セーブデータ情報のクラス
    # @return [RackResponseGenerator] Rack::Response 生成器
    def execute(httpRequestParseResult, serverClass, saveDirInfoClass)
      httpMethod = httpRequestParseResult.httpMethod

      unless httpRequestParseResult.validHttpMethod?
        return RackResponseGenerator.withNilMessage(
          httpMethod,
          Response::InvalidHttpMethodResponse.new(httpMethod)
        )
      end

      if httpRequestParseResult.exception
        return RackResponseGenerator.withNilMessage(
          httpMethod,
          Response::HttpRequestParseErrorResponse.new(
            httpRequestParseResult
          )
        )
      end

      if MsgpackLoader.failed?
        return RackResponseGenerator.withNilMessage(
          httpMethod,
          Response::MessagePackLoadFailureResponse.instance
        )
      end

      # 送信元により適切なクラス・モジュールを選ぶ
      messageClass, commandTable, responseModule =
        if httpRequestParseResult.webIf?
          [Message::MessageFromWebIf,
           Command::WebIfCommands,
           Response::WebIf]
        else
          [Message::MessageFromClient,
           Command::ClientCommands,
           Response::Client]
        end

      message = messageClass.fromHash(httpRequestParseResult.messageData)
      unless message.commandSpecified?
        # コマンドが指定されていないため中止する
        return RackResponseGenerator.new(
          httpMethod,
          message,
          responseModule::CommandNotSpecifiedResponse.new(
            serverClass::SERVER_TYPE
          )
        )
      end

      command = nil
      begin
        command = commandTable.fetch(message.commandName)
      rescue Command::CommandNotFoundError => e
        return RackResponseGenerator.new(
          httpMethod,
          message,
          Response::CommandNotFoundResponse.new(e)
        )
      end

      begin
        server = serverClass.new(saveDirInfoClass.new, message.args)
        result = command.execute(server, message.args)
        return RackResponseGenerator.new(
          httpMethod,
          message,
          Response::SuccessResponse.new(result)
        )
      rescue => e
        return RackResponseGenerator.new(
          httpMethod,
          message,
          Response::FailureResponse.new(e)
        )
      end
    end
  end
end
