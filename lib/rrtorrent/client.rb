module RRTorrent
  class Client < XMLRPC::Client
    def list_methods
      system.listMethods
    end

    def list_torrents
      rpcs = Torrent.property_rpc_names.map { |rpc| "#{rpc}=" }

      torrents.multicall('main', *rpcs).map do |torrent|
        Torrent.from_array(torrent)
      end
    end

    def get_torrent(id)
      Torrent.new(Torrent.values_for(self, id))
    end

    private

    def system
      @system ||= proxy('system')
    end

    def torrents
      @torrents ||= proxy('d')
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
