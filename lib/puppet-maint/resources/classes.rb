require 'puppet-maint/resource'

module PuppetMaint
  module Resources
    class Classes < Resource
      def get_files(module_dirs)
        super(module_dirs)
      end

      def used(module_dirs)
        file_list = get_files(module_dirs)

        classes = []
        files = []
        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token,i|
            if [:CLASS].include? token.first
              if [:LBRACE].include? tokens[i+1].first
                classes.push(tokens[i+2].last[:value].sub(/^::/,''))
              end
            elsif [:NAME].include? token.first
              if ["include","contain","require"].include? token.last[:value]
                classes.push(tokens[i+1].last[:value].sub(/^::/,''))
              elsif ["create_resources","ensure_resource"].include? token.last[:value]
                classes.push(tokens[i+2].last[:value])
              end
            elsif [:CLASSREF].include? token.first
              classes.push(token.last[:value].downcase)
            elsif [:INHERITS].include? token.first
              classes.push(tokens[i+1].last[:value])
            end
          end
          classes.uniq!
          files.push(file)
        end
        Hash[classes.zip files]
      end

      def declared(module_dirs)
        file_list = get_files(module_dirs)

        classes = []
        files = []
        file_list.each do |file|
          tokens = PuppetMaint.tokenize(file)
          tokens.each_with_index do |token,i|
            if [:CLASS].include? token.first
              classes.push(tokens[i+1].last[:value].sub(/^{/,''))
              break
            end
          end
          classes.delete("")
          classes.compact
          classes.uniq
          files.push(file)
        end
        Hash[classes.zip files]
      end

      def unused(module_dirs)
        used_classes = used(module_dirs)
        declared_resources = declared(module_dirs)
        used_classes.each do |type,file|
          declared_resources.reject! {|t,f| type.eql?(t) }
        end
        return declared_resources
      end
    end
  end
end
