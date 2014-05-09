require 'net/ping'
require 'colorize'

class VpnTest
  def test
    domains.each do |domain|
      ping(domain)
    end
  end

  private

  def ping(url)
    sum = 0
    bugs = 0
    5.times do
      from = Time.now
      pt = Net::Ping::External.new(url)
      if pt.ping
        sum += (Time.now - from) * 1000
      else
        puts "ping #{url}: #{pt.exception}".colorize(:yellow)
        bugs += 1
      end
    end
    outputs = "ping #{url} : #{(sum / 5).round}ms, failed: #{bugs}.times"
    color =
      if bugs == 0
        :green
      elsif bugs > 1 && bugs < 5
        :yellow
      elsif bugs == 5
        :red
      end
    puts outputs.colorize(color)
  end

  def domains
    host = 'example.com' # You Vpn Host name
    vpns =
      %w(us1 us2 us3 jp1 jp2 jp3 sg1 hk1 hk2 uk1).map do |name|
        "#{name}.#{host}"
      end
    vpns << 'www.baidu.com'
  end
end

class SwitchIp
  def go(vpn_name)
    turn_off vpn_name
    sleep 3
    turn_on vpn_name
  end

  def turn_on(vpn_name)
    system "/usr/bin/env osascript <<-EOF
        tell application \"System Events\"
          tell current location of network preferences
              set VPN to service \"#{vpn_name}\" -- your VPN name here
              if exists VPN then connect VPN
        end tell
      end tell
    EOF"
  end

  def turn_off(vpn_name)
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

vpn = VpnTest.new
vpn.test
puts 'Which VPN would you like?'
vpn_name = gets.strip
puts "Connecting to #{vpn_name}......"
ip = SwitchIp.new
ip.go vpn_name
