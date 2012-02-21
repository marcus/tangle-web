require 'nokogiri'
class Import::PersonalBrainImport

  def import
    f = File.open('import/TestBrain.xml')
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

  def create_node
    # Get the PB node content and guid
    content = t.xpath('name')[0].content
    guid = t.xpath('guid')[0].content

    # Save a tangle node
    tangle_node = Node.new(:title => content)
    tangle_node.save

    # Save the node to the map
    @node_map[guid] = tangle_node.uuid
  end

  def create_link(l)
    source_guid = l.xpath('idA')[0].content
    destination_guid = l.xpath('idB')[0].content
    direction = t.xpath('dir')[0].content
    # 1 = source is parent of destination
    # 2 = source is child of destination
    # 3 = siblings
  end

end
