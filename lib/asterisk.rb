require 'socket'

class Asterisk

  def initialize(caller_number, callee_number)
    @caller = caller_number
    @callee = callee_number
  end

  def login
    "Action: Login\r\nUsername: oigame\r\nSecret: #{APP_CONFIG[:ami_pass]}\r\nEvents: off"
  end

  def get_template
    "ACTION: Originate\r\nChannel: Local/#{@caller}@clickoutcontext\r\nExten: #{@callee}\r\nPriority: 1\r\nTimeout: 60000\r\nContext: clickincontext"
  end

  def make_call
    s = TCPSocket.new 'polar.oiga.me', 5038
    s.puts login
    s.puts ""
    s.puts get_template
    s.puts ""
    s.close
  end
end

