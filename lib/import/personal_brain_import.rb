require 'nokogiri'
class Import::PersonalBrainImport

  def get_doc(filename)
    path = "import/#{filename}"
    f = File.open(path)
    @doc = Nokogiri::XML(f) do |config|
      #config.options = Nokogiri::XML::ParseOptions.NOENT
      config.strict.noent
    end
    f.close
  end

  def doc
    @doc
  end

  def import(filename = 'TestBrain.xml')
    get_doc(filename) unless @doc

    @node_map = {}
    @thoughts = @doc.xpath('//Thought')
    @links = @doc.xpath('//Link')
    @descriptions = @doc.xpath('//Entry')
    #@attachments = @doc.xpath('//Attachment')

    create_nodes
    create_descriptions
    create_links
  end

  def create_nodes
    puts "Importing #{@thoughts.count} thoughts as notes"
    @thoughts.each_with_index { |t,i| create_node(t); dot(i) }
  end

  def create_descriptions
    puts "\nImporting #{@descriptions.count} notes/descriptions"
    @descriptions.each_with_index { |d,i| add_description(d); dot(i) }
  end

  def create_links
    puts "\nImporting #{@links.count} links"
    @links.each_with_index { |l, i| create_link(l); dot(i) }
  end

  def dot(index)
    if index % 10 == 0
      $stdout.sync = true
      print "."
    end
  end

  def create_node(thought)
    # Get the PB node content and guid
    content = thought.xpath('name')[0].content
    guid = thought.xpath('guid')[0].content
    created_at = thought.xpath('creationDateTime')[0].content
    updated_at = thought.xpath('realModificationDateTime').content
    activated = thought.xpath('activationDateTime')[0].content

    # Save a tangle node
    tangle_node = Node.new(
      :title => content,
      :created_at => created_at,
      :updated_at => updated_at,
      :activated => activated
    )#, :description => description)
    tangle_node.save

    ## Currently ignoring labels
    ## Currently ignoring types

    # Save the node to the map
    @node_map[guid] = tangle_node.uuid
  end

  # VERY SLOW; not used currently
  def find_description_for_guid(guid)
    note = @doc.at_xpath("//Entry//body[../guid/text()='#{guid}']")
    note ? note.children.first : nil
  end

  def add_description(d)
    node_guid = d.xpath('EntryObjects//EntryObject//objectID')[0].try(:content)
    content = d.xpath('body')[0].try(:content)
    if !content.blank?
      @decoder ||= HTMLEntities.new
      content = HtmlMassage.html(@decoder.decode(content))

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
    created_at = l.xpath('creationDateTime')[0].content
    updated_at = l.xpath('modificationDateTime').content
    # 1 = source is parent of destination
    # 2 = source is child of destination
    # 3 = companions
    if guid_a && guid_b && direction
      link = Link.new(:node_a_uuid => get_tangle_uuid(guid_a),
                      :node_b_uuid => get_tangle_uuid(guid_b),
                      :direction => direction,
                      :created_at => created_at,
                      :updated_at => updated_at
                     )
      link.save
    end
  end

  def get_tangle_uuid(guid)
    @node_map[guid]
  end

end
