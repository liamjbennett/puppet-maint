module PuppetMaint
  module Resources
    class Types < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)

      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        types = []
        files = []
        file_list.each do |file|
          content = File.open(file).read
          content.each_line do |line|
            if line.include?("Puppet::Type.newtype")
              f = line.sub("Puppet::Type.newtype(","").split("do")[0].sub(")","").sub(":","").strip
              types.push(f)
            end
          end
          types.uniq
          files.push(file)
        end
        return Hash[types.zip files]
      end
    end
  end
end
