module PuppetMaint
  module Resources
    class Functions < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)
        file_list = get_files(module_dirs)

        functions = []
        files = []
        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token,i|
            if [:NAME].include? token.first
              if [:LPAREN].include? tokens[i+1].first
                functions.push(token.last[:value]) if i >= 1
              end
            end
          end
          functions.uniq!
          files.push(file)
        end
        Hash[functions.zip files]
      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        functions = []
        files = []
        file_list.each do |file|
          content = File.open(file).read
          content.each_line do |line|
            if line.include?("newfunction")
              f = line.sub("Puppet::Parser::Functions::","").split(",")[0].sub("newfunction(","").sub(":","").strip
              functions.push(f)
            end
          end
          functions.uniq!
          files.push(file)
        end
        Hash[functions.zip files]
      end
    end
  end
end
