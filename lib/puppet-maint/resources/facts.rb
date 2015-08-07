module PuppetMaint
  module Resources
    class Facts < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)
        file_list = get_files(module_dirs)

        facts = []
        files = []
        file_list.each do |file|
          content = File.open(file).read
          content.each_line do |line|
            if line =~ /\$::\w+/
              facts.push(line.match(/\$::\w+/)[0].sub("$::",""))
            end
          end
          facts.uniq!
          files.push(file)
        end
        Hash[facts.zip files]
      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        facts = []
        files = []
        file_list.each do |file|
          content = File.open(file).read
          content.each_line do |line|
            if line.include?("Facter.add")
              f = line.lstrip.split("do")[0].split("{")[0].sub("Facter.add(","").sub(")","")
              if f.start_with?('"') or f.start_with?("'")
                fact_name = f.gsub('"','').gsub("'",'').strip
              elsif f.start_with?(":")
                fact_name = f.sub(":","").strip
              end
              facts.push(fact_name)
              files.push(file)
            end
          end
        end
        Hash[facts.zip files]
      end
    end
  end
end
