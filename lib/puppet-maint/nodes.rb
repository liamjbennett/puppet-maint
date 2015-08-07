require 'puppet-maint/resources/nodes'

module PuppetMaint
  class Nodes
    def check
      file_list = FileList.new('environments/**/manifests/*.pp') do |f1|
        PuppetMaint.exclude_environments.each do |env|
          f1.exclude("environments/#{env}/**/*.pp")
        end
      end

      nodes = PuppetMaint::Resources::Nodes.new
      known_nodes = nodes.used(PuppetMaint.db_servers)

      unused_defs = file_list.flat_map do |node_file|
        nodes.defined(node_file).reject do |node_def|
          re = Regexp.new node_def
          known_nodes.any? { |node| re =~ node }
        end.map { |node_def| [node_def, node_file] }
      end

      PuppetMaint.output("NODES",unused_defs,true)
    end
  end
end
