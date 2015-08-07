module PuppetMaint
  module Resources
    class Defines < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)
        file_list = get_files(module_dirs)

        defines = []
        files = []
        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token, i|
            if [:NAME].include? token.first
              if [:LBRACE].include? tokens[i+1].first and [:STRING, :SSTRING, :VARIABLE, :DQPRE, :LBRACK].include? tokens[i+2].first
                defines.push(token.last[:value])
              elsif ["create_resources","ensure_resource"].include? token.last[:value]
                defines.push(tokens[i+2].last[:value])
              end
            elsif [:CLASSREF].include? token.first
              defines.push(token.last[:value].downcase)
            end
          end
          defines.uniq!
          files.push(file)
        end
        Hash[defines.zip files]
      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        defines = []
        files = []
        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token,i|
            if [:DEFINE].include? token.first
              defines.push(tokens[i+1].last[:value].sub(/^{/,''))
              break
            end
          end
          defines.delete("")
          defines.compact
          defines.uniq
          files.push(file)
        end
        Hash[defines.zip files]
      end

      def unused(module_dirs)
        used_defines = used(module_dirs)
        declared_resources = declared(module_dirs)
        used_defines.each do |type, file|
          declared_resources.reject! {|t,f| type.eql?(t) }
        end
        return declared_resources
      end
    end
  end
end
