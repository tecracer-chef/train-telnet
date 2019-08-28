require "net/telnet"
require "train"

module TrainPlugins
  module Telnet
    class Connection < Train::Plugins::Transport::BaseConnection

      def initialize(options)
        super(options)
      end

      def close
        return if @session.nil?

        unless @options[:teardown]&.empty?
          logger.debug format("[Telnet] Sending teardown commands to %s:%d", @options[:host], @options[:port])
          execute_on_channel(@options[:teardown])
        end

        logger.info format("[Telnet] Closed connection to %s:%d", @options[:host], @options[:port])
        session.close
      ensure
        @session = nil
      end

      def uri
        "telnet://#{options[:user]}@#{@options[:host]}:#{@options[:port]}/"
      end

      def run_command_via_connection(cmd, &data_handler)
        logger.debug format("[Telnet] Sending command to %s:%d", @options[:host], @options[:port])
        exit_status, stdout, stderr = execute_on_channel(cmd, &data_handler)

        CommandResult.new(stdout, stderr, exit_status)
      end

      def execute_on_channel(cmd, &data_handler)
        if @options[:debug_telnet]
          logger.debug "[Telnet] => #{cmd}\n"
        end

        stdout = session.cmd(cmd)
        stderr = ""
        exit_status = 0

        # Output needs to be flushed first, so we don't skip a beat (Check why)
        session.waitfor("Waittime" => 0.1, "Match" => /./, "Timeout" => 0.1) rescue Net::ReadTimeout

        # Remove \r in linebreaks
        stdout.delete!("\r")

        if @options[:debug_telnet]
          logger.debug "[Telnet] <= '#{stdout}'"
        end

        # Extract command output only (no leading/trailing prompts)
        unless @options[:raw_output]
          stdout = stdout.match(/#{Regexp.quote(cmd.strip)}\n(.*?)\n#{@options[:prompt_pattern]}/m)&.captures&.first
        end
        stdout = "" if stdout.nil?

        # Simulate exit code and stderr
        errors = stdout.match(/^(#{@options[:error_pattern]})/)
        if errors
          exit_status = 1
          stderr = errors.captures.first
          stdout.gsub!(/^#{@options[:error_pattern]}/, "")
        end

        [exit_status, stdout, stderr]
      end

      def session(retry_options = {})
        @session ||= create_session
      end

      def create_session
        logger.info format("[Telnet] Opening connection to %s:%d", @options[:host], @options[:port])

        @session = Net::Telnet.new(
          "Host"   => @options[:host],
          "Port"   => @options[:port],
          "Prompt" => Regexp.new(@options[:prompt_pattern])
        )

        @session.login(
          "Name"           => @options[:user],
          "Password"       => @options[:password],
          "LoginPrompt"    => Regexp.new(@options[:login_prompt]),
          "PasswordPrompt" => Regexp.new(@options[:password_prompt])
        )

        unless @options[:setup].empty?
          logger.debug format("[Telnet] Sending setup commands to %s:%d", @options[:host], @options[:port])

          execute_on_channel(@options[:setup])
        end

        @session
      end

      def reset_session
        @session.close
      end
    end
  end
end
