module RRTorrent
  class Client < XMLRPC::Client
    TORRENT_VIEW = Set.new %i[main started stopped hashing seeding]

    def list_torrents(view = :main)
      values_for_torrent_view(view).map do |torrent|
        Torrent.new(torrent)
      end
    end

    def get_torrent(id)
      Torrent.new(values_for_torrent(id))
    end

    def get_torrents(ids)
      ids.map do |id|
        get_torrent(id)
      end
    end

    def update_torrent(torrent)
      values_for_torrent(torrent.id).each do |k, v|
        torrent.public_send("#{k}=", v)
      end
    end

    private

    def values_for_torrent_view(view)
      raise 'Invalid view' unless TORRENT_VIEW.include?(view)
      rpcs = Torrent.property_rpc_names.map { |rpc| "#{rpc}=" }
      call('d.multicall', view, *rpcs).map do |torrent|
        Torrent.properties.zip(torrent).to_h
      end
    end

    def values_for_torrents(ids)
      rpcs = ids.flat_map do |id|
        Torrent.property_rpc_names.zip([id].cycle)
      end

      vals = multicall(*rpcs)
      vals.each_slice(Torrent.properties.count).map do |torrent|
        Torrent.properties.zip(torrent).to_h
      end
    end

    def values_for_torrent(id)
      values_for_torrents(Array(id)).first
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
