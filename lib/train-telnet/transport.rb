require "train-telnet/connection"

module TrainPlugins
  module Telnet
    class Transport < Train.plugin(1)
      name "telnet"

      option :host,            required: true
      option :user,            required: true
      option :password,        required: true

      option :port,            default: 23
      option :raw_output,      default: false

      option :login_prompt,    default: "Username: "
      option :password_prompt, default: "Password: "
      option :setup,           default: ""
      option :teardown,        default: ""
      option :error_pattern,   default: "ERROR: .*$"
      option :prompt_pattern,  default: '(?:[-a-zA-Z0-9]+(?:\((?:config|config-[a-z]+|vlan)\))?[#>]\s*|\[\S+\]:\s*)$'

      # Non documented options for development
      option :debug_telnet,   default: false

      def connection(_instance_opts = nil)
        @connection ||= TrainPlugins::Telnet::Connection.new(@options)
      end
    end
  end
end
