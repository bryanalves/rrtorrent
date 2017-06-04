module RRTorrent
  class Torrent < OpenStruct
    PropertyMap = {
      id:                    'd.get_hash',
      name:                  'd.get_name',
      message:               'd.get_message',

      state:                 'd.get_state',
      state_changed:         'd.get_state_changed',
      is_active:             'd.is_active',
      complete:              'd.get_complete',
      is_hash_checking:      'd.is_hash_checking',
      is_open:               'd.is_open',

      priority:              'd.get_priority',

      up_rate:               'd.get_up_rate',
      up_total:              'd.get_up_total',
      down_rate:             'd.get_down_rate',
      down_total:            'd.get_down_total',
      ratio:                 'd.get_ratio',

      bytes_done:            'd.get_bytes_done',
      size_bytes:            'd.get_size_bytes',

      connected_peers:       'd.get_peers_accounted',
      connected_seeds:       'd.get_peers_complete',

      connected_peers_seeds: 'd.get_peers_connected',

      directory:             'd.get_directory',
      base_filename:         'd.get_base_filename',
      base_path:             'd.get_base_path',

      directory_base:        'd.get_directory_base',

      creation_date:         'd.get_creation_date',
      free_diskspace:        'd.get_free_diskspace',

      throttle_name:         'd.get_throttle_name',
      is_multi_file:         'd.is_multi_file',

      is_private:            'd.is_private',

      custom1:               'd.get_custom1',
      custom2:               'd.get_custom2'

    }.freeze

    def self.properties
      PropertyMap.keys
    end

    def self.property_rpc_names
      PropertyMap.values
    end

    def self.from_array(arr)
      Torrent.new(Torrent.properties.zip(arr).to_h)
    end
  end
end
