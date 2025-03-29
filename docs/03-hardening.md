# Nixtra - Hardening

Nixtra is a configuration that focuses on all three aspects of hardening, respectively; privacy, security and anonymity.

While Nixtra is hardened by default, there are some additional things you can do that would not be needed or wanted by most users. This section provides tips for further hardening various components of the system.

## Table of Contents

- [Sandboxing](##sandboxing)
- [Disable IPv6](##disable)
- [Spoof the Tor Exit Node IP address in Tor Browser](##spoofing)

## Sandboxing

You can sandbox applications in Nixtra to restrict their permissions, filesystem scope, networking capabilities, run them in some sort of container or anything else supported by the environment.

### Torify your applications

You can specify specific applications to be routed over the Tor network in your profile's configuration to maintain anonymity. To do so, simply call the `torify` function and provide the program you wish to be affected as an argument:

```nix
(pkgs.torify "${pkgs.freetube}/bin/freetube")
```

### Wrap applications with firejail

Firejail can encapsulate applications and force them to not use networking, or do things like restrict their filesystem access to a specific directory. Nixtra stores all firejail profiles in the `firejail` directory.

To wrap a program with Firejail, utilize the following Nixtra function in your [profile configuration](./02-configuration.md) inside `environment.systemPackages` or `home.packages`. For this example, the prismlauncher client for Minecraft is sandboxed as follows:

```nix
pkgs.wrapFirejail {
  executable = "${pkgs.prismlauncher}/bin/prismlauncher";
  profile = "prismlauncher";
}
```

Notice that the `profile` is set to the string `"prismlauncher"`. The overlay will implicitly translate this to the path `/etc/nixos/firejail/prismlauncher.profile` at build time.

Replace the package with the one you wish to encapsulate and the profile with a new one that you should create for it. For security reasons, the original package will be made inaccessible unless explicitly cloned in some way.

You can also compose different sandboxing solutions such as firejail with torify:

```nix
pkgs.wrapFirejail {
  executable = (pkgs.torify "${pkgs.prismlauncher}/bin/prismlauncher");
  profile = "prismlauncher";
}
```

## Disable IPv6

The Internet Protocol uses two primary methods of addressing; IPv4 and IPv6. IPv4 is the older version of the two and it is being phased away because the number of devices and people on the Internet exceed the number of available IPv4 addresses.

IPv6 mitigates this issue by simply providing a much larger address space. However, since IPv4 is still used, Internet Service Providers usually provide an IPv4 and an IPv6 address to home networks. This is called *IPv4/IPv6 dual stack*.

If you are using an anonymization network such as Tor with Tor Browser, you are already protected since the network primarily uses IPv4 and its flagship browser disables IPv6 by default. However, if you are using Tor without the browser suchs as with `torsocks`, consider disabling IPv6 entirely to prevent any potential [IPv6 leaks](https://www.ituonline.com/tech-definitions/what-is-ipv6-leak)

To see if IPv6 is causing leaks, visit [ipleak.net](https://ipleak.net) and see if your DNS server is pointing to your ISP's - if it is, you probably have a leak.

To disable IPv6, use the command:

```
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
```

> [!IMPORTANT]
> Some ISPs only provide IPv6 addresses and not IPv4. Check if your ISP provides you with an IPv4 address with `ip addr`.

## Spoof the Tor Exit Node IP Address in Tor Browser

> [!WARNING]
> This section explains how you can mask your Tor IP address by configuring a proxy to be used after traffic leaves the exit node. This may reduce your anonymity if done improperly. Make sure to restrict your usage of the Internet while this strategy is in use such that you cannot be tracked across several sites, but instead only the ones that block you.

### Introduction

Tor (Browser) is a great anonymity tool. However, some websites will block you or restrict your access to them in some way if they detect that you are using it. To do so, they check the IP address of the incoming traffic, which in this case is the exit node's, and they determine that it is a Tor IP address.

To circumvent this, you can use a post-exit proxy to mask your Tor IP address. This is sort of like using a bridge, which is a proxy for masking the entry node's IP address, but in this case it is the exit's since that is what the websites will see.

The proxy for the exit node can be configured with `proxychains` - a Linux program that hooks into system calls used by the target application and re-routes it to go through a chain of proxies.

In our case, our first proxy will be the Tor service running on the background. Tor Browser uses a service running on port 9050 as its network daemon, so we will use the socket address `127.0.0.1:9050`. Also, we need to add a second proxy in the chain that will be the actual proxy masking the Tor IP address. To find one, you can search for "socks5 proxy list" on a search engine and you will find many lists of public proxies you can use.

Also, we will run a [microsocks](https://github.com/rofl0r/microsocks) proxy server which will be the target program provided to proxychains. Any programs that connects to the microsocks proxy will use the proxy chain. That way, we do not have to start each target program e.g. Tor Browser with `proxychains`. If you do not already have these two installed, make sure to do so.

### Procedure

To begin, create a file `/etc/proxychains/proxy.conf` with the two proxies in the chain:

```
# Ensure that traffic will not be sent if any of the proxies in the below chain are not currently functional.
strict_chain

# Make proxy-related logging not appear.
#quiet_mode

tcp_read_time_out 15000
tcp_connect_time_out 8000

# The proxy chain list
[ProxyList]
socks5 127.0.0.1 9050 # Tor proxy
socks5 98.170.57.249 4145 # Find public proxies from e.g. https://github.com/proxifly/free-proxy-list
```

Also, create a file `/etc/proxychains/noproxy.conf` to be used when you do not want to route your traffic through the public proxy:

```
# Ensure that traffic will not be sent if any of the proxies in the below chain are not currently functional.
strict_chain

# Make proxy-related logging not appear.
#quiet_mode

tcp_read_time_out 15000
tcp_connect_time_out 8000

# The proxy chain list
[ProxyList]
socks5 127.0.0.1 9050 # Tor proxy
```

Next, launch Tor Browser normally and go to `about:config`. Since Tor Browser is bundled with the Tor service, we need to disable it so that proxychains properly routes traffic through our chain. If we did not do this, it would be routed through Tor twice. So, set these options in it respectively:

```
extensions.torlauncher.prompt_at_startup -> false
extensions.torbutton.use_nontor_proxy -> true
network.proxy.socks -> 127.0.0.1
network.proxy.socks_port -> 1080
network.trr.mode -> 0 (Optional)
```

- `network.proxy.socks_port` now points to `1080` which is the port that will be used by the microsocks proxy.
- `extensions.torbutton.use_nontor_proxy` is set to `true` so that Tor does not block the microsocks proxy.
- `network.trr.mode` is set to `0` so that the client can optionally access .onion links.

> [!WARNING]
> SSL/TLS might not function properly when the public proxy is in use. If a security warning is given when accessing a website via SSL, use another proxy that supports HTTPS.

Afterwards, we have to start a microsocks proxy server with the proxychains configuration by passing the program as an argument to it:

```
proxychains4 -f /etc/proxychains/proxy.conf microsocks -i 127.0.0.1 -p 1080
```

Alternatively, if you do not want to use the public proxy:

```
proxychains4 -f /etc/proxychains/noproxy.conf microsocks -i 127.0.0.1 -p 1080
```

Finally, start Tor Browser like normal and it should use the SOCKS5 proxy at port 1080, which in turn has its data intercepted and passed through our chain. You can visit `deviceinfo.me` to confirm that the setup is working - if it is, "Tor IP Address" will be set to false and the "IP Address" field will be set to the one used by the final proxy in the proxychain.

If you want to permanently stop using the proxy, you need to revert the changes done to `about:config` since that configures Tor Browser to not use Tor when not run with `proxychains`.

> [!WARNING]
> Ensure that no [DNS Leaks](https://en.wikipedia.org/wiki/DNS_leak) occur when running Tor with proxychains.

> [!IMPORTANT]
> After you confirm that the proxy setup works, check that "Proxy IP Address" in deviceinfo.me says "None detected". If it is, websites may still block your connection.
