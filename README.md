VPNcloud Helper is a tool for testing your network connect to VPNcloud VPN servers.

## Installation

```console
bundle install
```

## Config
Change xx.example.com to your domain name.

## And Run

```console
ruby ping.rb
```

```console
@hodo ➜  vpncloud-helper rvm:(ruby-1.9.3) git:(master) ruby ping.rb
ping baidu.com : 41ms, failed: 0.times
ping us1.example.com : 189ms, failed: 0.times
ping us2.example.com : 242ms, failed: 0.times
ping us3.example.com : 271ms, failed: 0.times
ping jp1.example.com : 91ms, failed: 0.times
ping jp2.example.com : 91ms, failed: 0.times
ping jp3.example.com : 113ms, failed: 0.times
ping sg1.example.com : 106ms, failed: 0.times
ping uk1.example.com : 400ms, failed: 0.times
```

## 2013-12-11

Fixed vpnclound address.

[![Code Climate](https://codeclimate.com/github/bydmm/vpncloud-helper.png)](https://codeclimate.com/github/bydmm/vpncloud-helper)