require 'net/ping'
require 'colorize'

def ping url
  sum = 0
  bugs = 0
  5.times do
    from = Time.now
    pt = Net::Ping::External.new(url)
    if pt.ping 
      cost = Time.now - from
      sum = sum + cost * 1000
    else
      if bugs == 0
        puts "ping #{url}: #{pt.exception}".colorize( :yellow )
      end
      bugs = bugs + 1
    end
  end
  sum = (sum / 5).round
  outputs = "ping #{url} : #{sum}ms, failed: #{bugs}.times"
  if bugs == 0
    puts outputs.colorize( :green )
  elsif bugs > 1 and bugs < 5
    puts outputs.colorize( :yellow )
  elsif bugs == 5
    puts outputs.colorize( :red )
  end
end

class SwitchIp

  def go vpn_name
    turn_off vpn_name
    sleep 3
    turn_on vpn_name
  end

  def turn_on vpn_name
    system "/usr/bin/env osascript <<-EOF
        tell application \"System Events\"
          tell current location of network preferences
              set VPN to service \"#{vpn_name}\" -- your VPN name here
              if exists VPN then connect VPN
        end tell
      end tell
    EOF"

  end

  def turn_off vpn_name
    system "/usr/bin/env osascript <<-EOF
      tell application \"System Events\"
        tell current location of network preferences
              set VPN to service \"#{vpn_name}\" -- your VPN name here
              if exists VPN then disconnect VPN
        end tell
    end tell
   EOF"
  end

end

ping "www.baidu.com"
ping 'us1.example.com'
ping 'us2.example.com'
ping 'us3.example.com'
ping 'jp1.example.com'
ping 'jp2.example.com'
ping 'jp3.example.com'
ping 'sg1.example.com'
ping 'hk1.example.com'
ping 'hk2.example.com'
ping 'uk1.example.com'

puts "Which VPN would you like?"
vpn_name = gets.strip
puts "Connecting to #{vpn_name}......"
vpn = SwitchIp.new
vpn.go vpn_name