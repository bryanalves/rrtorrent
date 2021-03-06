module RRTorrent
  class Backend < XMLRPC::Client
    include BackendModules::Torrent

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
