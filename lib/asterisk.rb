require 'net/telnet'

class Asterisk

  def initialize(caller_number, callee_number)
    @caller = caller_number
    @callee = callee_number
    @socket = make_connection
  end

  def login
    tpl = "Action: Login\nUsername: oigame\nSecret: #{APP_CONFIG[:ami_pass]}\nEvents: off"
    send_action(tpl)
    
    return process_lines
  end

  def originate
    login
    tpl = "ACTION: Originate\nChannel: Local/#{@caller}@clickoutcontext\nExten: #{@callee}\nPriority: 1\nTimeout: 60000\nContext: clickincontext"
    send_action(tpl)

    return process_lines
  end

  def channels
    @socket = make_connection
    login
    tpl = "ACTION: Status"
    send_action(tpl)

    str = process_lines
    arr = str.split("\n")

    return process_channel_data(arr)
  end

  def process_channel_data(arr)
    arr = arr[3..-1].split("")
    data = {}
    
    first = arr.first
    last = arr.last

    chan = ""
    first.each do |a|
      if a.match(/Channel: /)
        chan = a.split("\s").last
      elsif a.match(/ChannelStateDesc: /)
        state = a.split("\s").last
        data[chan] = state
      end
    end

    chan = ""
    last.each do |a|
      if a.match(/Channel: /)
        chan = a.split("\s").last
      elsif a.match(/State: /)
        state = a.split("\s").last
        data[chan] = state
      end
    end

    return data
  end

  def make_connection
    Net::Telnet::new("Host" => "polar.oiga.me", "Port" => 5038)
  end

  def disconnect
    @socket.close
  end

  protected

  def process_lines
    data = ""
    @socket.waitfor(/\n/) do |txt|
      txt.split("\n").each do |line|
        data += line+"\n"
      end
    end

    return data
  end

  def send_action(tpl)
    @socket.puts tpl
    sleep 2
    @socket.puts ""
    sleep 1
  end
end

