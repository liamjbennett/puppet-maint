module PuppetMaint
  module Resources
    class Nodes < Resource
      def defined(file)
        tokens = PuppetMaint.tokenize(file)
        tokens.each_with_index.select do |token, _|
          token.first == :NODE
        end.flat_map do |token, idx|
          tokens[idx+1..-1].take_while do |tok|
            tok.first != :LBRACE
          end.map do |tok|
            tok.last[:value]
          end.reject do |tok|
            tok == "," || tok == "default"
          end
        end
      end

      def puppetdb_nodes(db)
        http = Net::HTTP.new(db, 8080)
        nodes = http.request(Net::HTTP::Get.new("/v3/nodes"))
        JSON.parse(nodes.body)
      end

      def used(db_servers)
        db_servers.flat_map do |db|
          puppetdb_nodes(db).map { |node| node["name"] }
        end
      end

      def unused

      end
    end
  end
end
