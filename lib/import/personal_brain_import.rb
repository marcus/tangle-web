require 'nokogiri'
class Import::PersonalBrainImport

  def import
    # f = File.open('import/TestBrain.xml')
    f = File.open('import/marcus_brain.xml')
    doc = Nokogiri::XML(f)
    f.close

    @node_map = {}
    @thoughts = doc.xpath('//Thought')
    @links = doc.xpath('//Link')
    @notes = doc.xpath('//Entry')
    @attachments = doc.xpath('//Attachment')

    create_nodes
    create_links
  end

  def create_nodes
    @thoughts.each { |t| create_node(t) }
  end

  def create_links
    @links.each { |l| create_link(l)}
  end

  def create_node(thought)
    # Get the PB node content and guid
    content = thought.xpath('name')[0].content
    guid = thought.xpath('guid')[0].content

    # Save a tangle node
    tangle_node = Node.new(:title => content)
    tangle_node.save

    # Save the node to the map
    @node_map[guid] = tangle_node.uuid
  end

  def create_link(l)
    guid_a = l.xpath('idA')[0].try(:content)
    guid_b = l.xpath('idB')[0].try(:content)
    direction = l.xpath('dir')[0].try(:content)
    # 1 = source is parent of destination
    # 2 = source is child of destination
    # 3 = companions
    if guid_a && guid_b && direction
      link = Link.new(:node_a_uuid => get_tangle_uuid(guid_a),
                      :node_b_uuid => get_tangle_uuid(guid_b),
                      :direction => direction)
      link.save
    end
  end

  def get_tangle_uuid(guid)
    @node_map[guid]
  end

end
