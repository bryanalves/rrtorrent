module RRTorrent
  module BackendModules
    module Torrent
      TORRENT_VIEW = Set.new %i[main started stopped hashing seeding]

      def values_for_torrent_view(view)
        raise 'Invalid view' unless TORRENT_VIEW.include?(view)
        rpcs = Model::Torrent.property_rpc_names.map { |rpc| "#{rpc}=" }
        call('d.multicall', view, *rpcs).map do |torrent|
          Model::Torrent.properties.zip(torrent).to_h
        end
      end

      def values_for_torrents(ids)
        rpcs = ids.flat_map do |id|
          Model::Torrent.property_rpc_names.zip([id].cycle)
        end

        vals = multicall(*rpcs)
        vals.each_slice(Model::Torrent.properties.count).map do |torrent|
          Model::Torrent.properties.zip(torrent).to_h
        end
      end

      def values_for_torrent(id)
        values_for_torrents(Array(id)).first
      end
    end
  end
end
