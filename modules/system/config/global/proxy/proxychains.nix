{ profile, ... }:

{
  environment.etc."proxychains.conf".text = ''
    # Ensure that traffic will not be sent if any of the proxies in the below chain are not currently functional.
    strict_chain

    # Make proxy-related logging not appear.
    quiet_mode
    
    # Proxy all DNS queries through the proxychain
    proxy_dns

    # Public proxy may take time to load
    tcp_read_time_out 30000
    tcp_connect_time_out 30000

    # The proxy chain list
    [ProxyList]
    socks5 127.0.0.1 9150 # Tor service for proxy
    socks5 ${profile.tor.publicProxy.address} ${builtins.toString profile.tor.publicProxy.port}
  '';
}
