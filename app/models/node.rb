class Node < ActiveRecord::Base
  # TODO - sanitize title and description
  include Shared::UUID
  # 1 = NodeA is parent of NodeB
  # 2 = NodeA is child of NodeB
  # 3 = NodeA and NodeB are companions

  # Children
  # nodeB where nodeA = uuid AND direction = 1
  # nodeA where nodeB = uuid AND direction = 2
  #
  # Parents
  # nodeA where nodeB = uuid AND direction = 1
  # nodeB where nodeA = uuid AND direction = 2
  #
  # Companions
  # nodeB where nodeA = uuid AND direction = 3
  # nodeA where nodeB = uuid AND direction = 3
  #
  # Siblings
  # children of parents

  def children_links
    Link.where ['(node_a_uuid = ? AND direction = ?) OR (node_b_uuid = ? AND direction = ?)', uuid, 1, uuid, 2]
  end

  def child_uuids
    children_links.map{ |cl|
      cl.direction == 1 ? cl.node_b_uuid : cl.node_a_uuid
    }
  end

  def children
    Node.where uuid: child_uuids
  end

  def parent_links
    Link.where ['(node_b_uuid = ? AND direction = ?) OR (node_a_uuid = ? AND direction = ?)', uuid, 1, uuid, 2]
  end

  def parent_uuids
    parent_links.map { |pl|
      pl.direction == 1 ? pl.node_a_uuid : pl.node_b_uuid
    }
  end

  def parents
    Node.where uuid: parent_uuids
  end

  def companion_links
    Link.where ['(node_a_uuid = ? AND direction = ?) OR (node_b_uuid = ? AND direction = ?)', uuid, 3, uuid, 3]
  end

  def companion_uuids
    companion_links.map { |cl|
      cl.node_a_uuid == uuid ? cl.node_b_uuid : cl.node_a_uuid
    }
  end

  def companions
    Node.where uuid: companion_uuids
  end

  def sibling_uuids
    uuids = {}
    parents.each{ |p| uuids[p.uuid] = p.child_uuids.reject{ |n| n == uuid } }
    uuids
  end

  def siblings
    sibs = {}
    sibling_uuids.each{ |s,v| sibs[s] = Node.where(uuid: v) }
    sibs
  end

  def to_json(options={})
    n = {
      :uuid => uuid,
      :title => title,
      :description => description
    }
    n.merge!(relationship_uuids)
    n.merge!(relationships) unless options[:shallow] == true
    n
  end

  # All links in a single query
  def related_links
    links = Link.where ['(node_a_uuid = ?) OR (node_b_uuid = ?)', uuid, uuid]
    {
      :parents => links.select{ |l| (l.node_b_uuid == uuid && l.direction == 1) || (l.node_a_uuid == uuid && l.direction == 2) },
      :children => links.select{ |l| (l.node_a_uuid == uuid && l.direction == 1) || (l.node_b_uuid == uuid && l.direction == 2) },
      :companions => links.select{ |l| (l.node_a_uuid == uuid && l.direction == 3) || (l.node_b_uuid == uuid && l.direction == 3) }
    }
  end

  def relationships
    # Probably faster to gather everything into one query, then sort afterwards
    # - write methods that are "relationships for nodes" which will take a big list and sort
    # them into relationship buckets
    ru = relationship_uuids
    {
      :parents => Node.where(uuid: ru[:parent_uuids]).map{ |n|n.to_json(:shallow => true) },
      :children => Node.where(uuid: ru[:child_uuids]).map{ |n|n.to_json(:shallow => true) },
      :companions => Node.where(uuid: ru[:companion_uuids]).map{ |n|n.to_json(:shallow => true) }#,
      #:siblings => Node.where_uuid(ru[:siblings]).map{ |n|n.to_json(:shallow => true) }
    }
  end

  def relationship_uuids
    rl = related_links
    {
      :child_uuids => rl[:children].map{ |cl| cl.direction == 1 ? cl.node_b_uuid : cl.node_a_uuid },
      :parent_uuids => rl[:parents].map{ |pl| pl.direction == 1 ? pl.node_a_uuid : pl.node_b_uuid },
      :companion_uuids => rl[:companions].map{|cl| cl.node_a_uuid == uuid ? cl.node_b_uuid : cl.node_a_uuid }#,
      #:sibling_uuids =>
    }
  end

end

# reload!; i = Import::PersonalBrainImport.new; i.import
