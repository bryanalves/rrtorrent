module RRTorrent
  class Client
    def initialize(host, port)
      @backend = Backend.new_from_hash(host: host, port: port)
    end

    def list_torrents(view = :main)
      @backend.values_for_torrent_view(view).map do |torrent|
        Model::Torrent.new(torrent)
      end
    end

    def get_torrent(id)
      Model::Torrent.new(@backend.values_for_torrent(id))
    end

    def get_torrents(ids)
      ids.map do |id|
        get_torrent(id)
      end
    end

    def update_torrent(torrent)
      @backend.values_for_torrent(torrent.id).each do |k, v|
        torrent.public_send("#{k}=", v)
      end
    end
  end
end
