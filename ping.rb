require 'net/ping'
require 'colorize'

# No more Talk and **** RuboCop
class VpnTest
  def test
    domains.each do |domain|
      ping(domain)
    end
    puts 'Which VPN would you like?'
    vpn_name = gets.strip
    puts "Connecting to #{vpn_name}......"
    ip = SwitchIp.new
    ip.go vpn_name
  end

  private

  def ping(url)
    result = connect(url)
    sum, bugs = result[:sum], result[:bugs]
    outputs = "ping #{url} : #{sum}ms, failed: #{bugs}.times"
    color = bug_color(bugs)
    puts outputs.colorize(color)
  end

  def bug_color(bugs)
    if bugs == 0 then :green
    elsif bugs > 0 && bugs < 5 then :yellow
    elsif bugs == 5 then :red
    end
  end

  def connect(url)
    sum, bugs = 0, 0
    5.times do
      from = Time.now
      pt = Net::Ping::External.new(url)
      if pt.ping
        sum += (Time.now - from) * 1000
      else
        bugs += 1
      end
    end
    { sum: (sum / 5).round, bugs: bugs }
  end

  def domains
    host = 'example.com' # You Vpn Host name
    vpns =
      %w(us1 us2 us3 jp1 jp2 jp3 sg1 hk1 hk2 uk1).map do |name|
        "#{name}.#{host}"
      end
    vpns << 'www.baidu.com'
  end

  # No more Talk and **** RuboCop
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
end

vpn = VpnTest.new
vpn.test
