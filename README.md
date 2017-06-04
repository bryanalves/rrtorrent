RRTorrent
--

An XMLRPC client for RTorrent.

Sample usage:

```
require 'rrtorrent'

client = RRTorrent::Client.new_from_hash({host: '192.168.1.101', port: 5000})

torrents = client.list_torrents

client.update_torrent(torrents.first)

torrent = client.get_torrent('0A12345...')
```
