module PuppetMaint
  module Resources
    class Providers < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)
        file_list = get_files(module_dirs)

        providers = []
        files = []

        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token,i|
            if [:NAME].include? token.first
              if token.last[:value].eql?("provider") and [:FARROW].include? tokens[i+1].first
                providers.push(tokens[i+2].last[:value])
              end
            end
          end
          providers.uniq!
          files.push(file)
        end
        Hash[providers.zip files]
      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        providers = []
        files = []

        file_list.each do |file|
          content = File.open(file).read
          content.each_line do |line|
            if line.include?("Puppet::Type.type") and !line.start_with?("#")
              f = line.split(".provide").last.sub("(","").sub(")","").sub(" do","").strip
              f = f.split(",").first
              f.sub!(":","") if !f.nil?
              providers.push(f)
              break
            end
            providers.uniq!
            files.push(file)
          end
        end
        Hash[providers.zip files]
      end
    end
  end
end
