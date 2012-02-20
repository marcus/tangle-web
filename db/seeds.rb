# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# YES, THIS DOES DELETE ALL NODES
Node.all.each {|n| n.destroy}

nodes = [
  foosball = Node.create({:title => "Foosball", :description => "A game of skill"}),
  ping_pong = Node.create({:title => "Ping Pong", :description => "A game of agility"}),
  billiards = Node.create({:title => "Billiards", :description => "A game of smoke and mirrors"}),

  board_games = Node.create({:title => "Board Games", :description => "Games played on boards"}),
  table_games = Node.create({:title => "Table Games", :description => "Games played on tables"}),
  games = Node.create({:title => "Games", :description => "Recreational activites"})
]

foosball.update_attributes :parent_uuids => [table_games.uuid], :sibling_uuids => [ping_pong.uuid, billiards.uuid]
ping_pong.update_attributes :parent_uuids => [table_games.uuid], :sibling_uuids => [foosball.uuid, billiards.uuid]
billiards.update_attributes :parent_uuids => [table_games.uuid], :sibling_uuids => [foosball.uuid, ping_pong.uuid]

board_games.update_attributes :parent_uuids => [games.uuid], :sibling_uuids => [table_games.uuid], :child_uuids => [foosball.uuid, ping_pong.uuid, billiards.uuid]
table_games.update_attributes :parent_uuids => [games.uuid], :sibling_uuids => [board_games.uuid]

games.update_attributes :parent_uuids => [], :child_uuids => [board_games.uuid, table_games.uuid]
