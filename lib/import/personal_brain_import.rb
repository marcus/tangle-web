require 'nokogiri'
class Import::PersonalBrainImport

  def get_doc#(path = 'import/marcus_brain.xml')
    #path = 'import/TestBrain.xml'
    path = 'import/marcus_brain.xml'
    f = File.open(path)
    @doc = Nokogiri::XML(f)
    f.close
    @doc
  end

  def import
    get_doc unless @doc

    @node_map = {}
    @thoughts = @doc.xpath('//Thought')
    @links = @doc.xpath('//Link')
    @descriptions = @doc.xpath('//Entry')
    @attachments = @doc.xpath('//Attachment')

    create_nodes
    create_descriptions
    create_links
  end

  def create_nodes
    @thoughts.each { |t| create_node(t) }
  end

  def create_descriptions
    @descriptions.each { |d| add_description(d) }
  end

  def create_links
    @links.each { |l| create_link(l)}
  end

  def create_node(thought)
    # Get the PB node content and guid
    content = thought.xpath('name')[0].content
    guid = thought.xpath('guid')[0].content

    #@decoder ||= HTMLEntities.new
    #description = @decoder.decode find_description_for_guid(guid)

    # Save a tangle node
    tangle_node = Node.new(:title => content)#, :description => description)
    tangle_node.save

    # Save the node to the map
    @node_map[guid] = tangle_node.uuid
  end

  # VERY SLOW; not used currently
  def find_description_for_guid(guid)
    note = @doc.at_xpath("//Entry//body[../guid/text()='#{guid}']")
    note ? note.children.first : nil
  end

  def add_description(d)
    node_guid = d.xpath('//EntryObjects//EntryObject//objectID')[0].try(:content)
    content = d.xpath('//body')[0].try(:content)
    if content
      @decoder ||= HTMLEntities.new
      content = @decoder.decode content

      node = Node.find(@node_map[node_guid])
      if node
        node.update_attributes!(:description => content)
        node.save
      else
        puts "Could not find node for description"
      end
    end
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
