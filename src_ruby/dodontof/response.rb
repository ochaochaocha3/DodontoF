# -*- coding: utf-8 -*-

module DodontoF
  # 応答クラスを格納するモジュール
  module Response
  end
end

require 'dodontof/response/invalid_http_method_response'
require 'dodontof/response/http_request_parse_error_response'
require 'dodontof/response/message_pack_load_failure_response'
require 'dodontof/response/client/command_not_specified_response'
require 'dodontof/response/web_if/command_not_specified_response'
require 'dodontof/response/command_not_found_response'
require 'dodontof/response/success_response'
require 'dodontof/response/failure_response'
