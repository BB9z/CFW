低调～

Update @2018:

PAC 方式不推荐使用了，需要经常维护。如果你需要写一个 PAC 可以参考这个，当初写的时候 PAC 能用的技术基本上都包括了。

推荐使用 SpechtLite，它支持通过访问速度决定是走代理还是直连的功能，有了这个基本上不需要维护规则了。

SpechtLite 自带 ShadowsocksX，但是速度很慢，推荐 ShadowsocksX-NG。

现在用的规则很简单，除了 adapter 部分和最后的 all，其他是默认的。

```yaml
# This is the local http proxy server port.
# Note there is another SOCKS5 proxy server starts at port+1 automatically.
port: 9090
# Adapter is the remote proxy server you want to connect to
adapter:
     # id is used to distinguish adapter when defining rules.
     # There is a 'direct' adapter that connect directly to target host without proxy.
  - id: proxy
    type: HTTP
    host: 0.0.0.0
    port: 1087
    auth: false
  - id: speed
    type: SPEED
    adapters:
      - id: proxy
        delay: 1500
      - id: direct
        delay: 0
  # Disconnect after given delay without connecting to remote.
  - id: reject
    type: reject
    # It's very important to set a delay since some apps may try to reconnect repeatedly.
    delay: 300
# Here defines how things should work.
# Rule will be matched one by one.
rule:
  - type: iplist
  # Forward polluted host IP address
    file: ~/.SpechtLite/pollutedip
    adapter: proxy
  - type: list
  # Forward requests based on whether the host domain matches the given regular expressions.
    file: ~/.SpechtLite/directlist
    adapter: direct
  - type: iplist
  # Forward requests based on the IP address of the host.
    file: ~/.SpechtLite/directiprange
    adapter: direct
  - type: list
  # Forward requests based on whether the host domain matches the given regular expressions.
    file: ~/.SpechtLite/proxylist
    adapter: proxy
  - type: iplist
  # Forward requests based on the IP address of the host.
    file: ~/.SpechtLite/proxyiprange
    adapter: proxy
  - type: list
  # Reject requests based on whether the host domain matches the given regular expressions.
    file: ~/.SpechtLite/rejectlist
    adapter: reject
  - type: iplist
  # Reject requests based on the IP address of the host.
    file: ~/.SpechtLite/rejectiprange
    adapter: reject
  - type: country
  # When the location is unknown. Usually this means this is resolved an Intranet IP.
    country: CN
    match: true
    adapter: direct
  - type: country
  # When the location is unknown. Usually this means this is resolved an Intranet IP.
    country: --
    match: true
    adapter: direct
  - type: DNSFail
  # When the DNS lookup of the host fails.
    adapter: proxy
  - type: all
  # Match all other requests.
    adapter: speed
```

---

最新 PAC 文件 URL 可使用

```
https://bb9z.github.io/CFW/RFCFW.pac
```

### Links

* https://github.com/zhuhaow/SpechtLite
* https://github.com/shadowsocks/ShadowsocksX-NG
