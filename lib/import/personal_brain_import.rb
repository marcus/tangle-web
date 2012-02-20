require 'nokogiri'
class Import::PersonalBrainImport

  def import
    f = File.open('import/TestBrain.xml')
    doc = Nokogiri::XML(f)
    f.close

    thoughts = doc.xpath('//Thought')
    links = doc.xpath('//Link')
    notes = doc.xpath('//Entry')
    attachments = doc.xpath('//Attachment')

    create_nodes(thoughts)
  end

  def create_nodes(thoughts)
    thoughts.each do |t|
      content = t.xpath('name')[0].content
      guid = t.xpath('guid')[0].content
      Node.new(:title => content).save
    end
  end

end
