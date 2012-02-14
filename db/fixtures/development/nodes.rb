Node.seed(:uuid,
  { :id => 1, :uuid => '1xxxx', :title => "Foosball", :description => "A game of skill" },
  { :id => 2, :uuid => '2xxxx', :title => "Baskeball", :description => "A game of physical prowess" },
  { :id => 3, :uuid => '3xxxx', :title => "Games", :description => "Recreational activites" }
)
Link.seed(:node_uuid, :relationship_uuid,
  { :node_uuid => '1xxxx', :relationship_uuid => '2xxxx', :relationship_type => 'parent'},
  { :node_uuid => '2xxxx', :relationship_uuid => '1xxxx', :relationship_type => 'child'},

  { :node_uuid => '2xxxx', :relationship_uuid => '3xxxx', :relationship_type => 'parent'},
  { :node_uuid => '3xxxx', :relationship_uuid => '2xxxx', :relationship_type => 'child'}
)
