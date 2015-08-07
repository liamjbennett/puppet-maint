module PuppetMaint
  module Resources
    class Resource

      def get_files(module_dirs)
        FileList.new do |f|
          module_dirs.each do |dir|
            f.include(dir)
          end
        end
      end

      def self.used(type_obj, module_dirs)
        file_list = get_files(module_dirs)

        types = []
        files = []
        file_list.each do |file|
          type = type_obj.used(file)
          if type and !type.empty?
            type.each do |t|
              if !types.include?(t)
                types.push(t)
                files.push(file)
              end
            end
          end
        end
        Hash[types.zip files]
      end

      def self.declared(type_obj, module_dirs)
        file_list = get_files(module_dirs)

        types = []
        files = []
        file_list.each do |file|
          type = type_obj.declared(file)
          if type and !type.empty?
            type.each do |t|
              if !types.include?(t)
                types.push(t)
                files.push(file)
              end
            end
          end
        end
        Hash[types.zip files]
      end
    end
  end
end
