module RRTorrent
  class Client < XMLRPC::Client
    TORRENT_VIEW = {
      main:    'main',
      started: 'started',
      stopped: 'stopped',
      hashing: 'hashing',
      seeding: 'seeding'
    }.freeze

    def list_torrents(view = :main)
      rpcs = Torrent.property_rpc_names.map { |rpc| "#{rpc}=" }

      call('d.multicall', TORRENT_VIEW[view], *rpcs).map do |torrent|
        Torrent.from_array(torrent)
      end
    end

    def get_torrent(id)
      Torrent.new(values_for_torrent(id))
    end

    def update_torrent(torrent)
      values_for_torrent(torrent.id).each do |k, v|
        torrent.public_send("#{k}=", v)
      end
    end

    private

    def values_for_torrent(id)
      vals = multicall(*Torrent.property_rpc_names.zip([id].cycle))
      Torrent.properties.zip(vals).to_h
    end

    def do_rpc(xml, _async = false)
      headers = {
        'CONTENT_LENGTH' => xml.size,
        'SCGI' => 1
      }

      header = headers.to_a.flatten.join("\x00")
      request = "#{header.size}:#{header},#{xml}"

      TCPSocket.open(@host, @port) do |s|
        s.write(request)
        s.read.split(/\n\s*?\n/, 2)[1]
      end
    end
  end
end
