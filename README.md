RRTorrent
--

An XMLRPC client for RTorrent.

Sample usage:

```
require 'rrtorrent'

client = RRTorrent::Client.new('192.168.1.101', 5000)

torrents = client.list_torrents

client.update_torrent(torrents.first)

torrent = client.get_torrent('0A12345...')
```
