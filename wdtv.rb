@hostname = ENV['WDTVHOST'] || 'WDTVLive'

require 'net/telnet'

def play stream
  if telnet_connection
    telnet_connection.cmd("/usrdata/upnp-cmd SetAVTransportURI #{stream}") 
    telnet_connection.cmd('/usrdata/upnp-cmd Play')
    telnet_connection.close
  else 
    puts "Cannot access the WDTV Live. Ensure you have installed the exploit!"
  end
end

def install
  if telnet_connection
    telnet_connection.close
    puts "WDTVLive exploit already installed!" 
    return
  end
  
  `sh telnetd_launcher.sh #{@hostname}`
  
  if telnet_connection
    telnet_connection.cmd('touch /usrdata/upnp-cmd')
    telnet_connection.cmd("cat <<- 'EOF' > /usrdata/upnp-cmd")
    telnet_connection.cmd(File.open('upnp-cmd').read)
    telnet_connection.cmd('EOF')  
    telnet_connection.cmd('chmod +x /usrdata/upnp-cmd') 
    telnet_connection.close
    puts "WDTVLive exploit installed!"
  else 
    puts "Could not install WDTVLive exploit! Please try again"
  end
end

def usage
  puts ''
  puts 'This script can be used to play HTTP streams on a WDTV Live device (gen3) using the standard firmware.'
  puts ''
  puts '* Usage: ruby wdtv.rb command [command options]'
  puts '* The default host is WDTVLive, you can override this by setting the WDTVHOST environment variable'
  puts '* Available commands:'
  puts '  * install           - Installs the exploit needed to send commands to the WDTV. Only needs to be executed once'
  puts '  * play <stream uri> - Tells the WDTV to play a stream. For example: play http://example.com/stream.mp4'
  puts ''  
end

def telnet_connection
  @telnet_connection ||= Net::Telnet::new('Host' => @hostname, 'Timeout' => 10, 'Prompt' => /[$%#>] \z/n) rescue nil
end

# INIT
case ARGV[0]
  when 'install' then install
  when 'play' then play(ARGV[1])
  else usage
end