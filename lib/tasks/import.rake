namespace :import do
  # Usage: rake import:pb['marcus_brain.xml'] - place file in import directory first
  desc "Import personal brain"
  task :pb, [:filename] => [:environment] do |t, args|
    args.with_defaults(:filename => 'TestBrain.xml')
    require(Rails.root.join('lib/import/personal_brain_import.rb'))

    i = Import::PersonalBrainImport.new
    i.import(args[:filename])
    puts "\nCreated #{Link.all.count} links and #{Node.all.count} nodes."
  end

  desc "Drop existing nodes and links"
  task :drop => :environment do
    puts "Destroying #{Link.all.count} links and #{Node.all.count} nodes."
    Link.destroy_all
    puts "Links destroyed."
    Node.destroy_all
    puts "Nodes and Links are gone."
  end

  desc "Node and link stats"
  task :stats => :environment do
    puts "Links: #{Link.all.count}"
    puts "Nodes: #{Node.all.count}"
  end
end
