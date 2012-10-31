xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "oiga.me"
    xml.description t(:description)
    xml.link "#{APP_CONFIG[:domain]}/"

    @campaigns.each do |campaign|
      xml.item do
        xml.title campaign.name
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
          :autolink => true, :space_after_headers => true)
        xml.description image_tag(campaign.image_url.to_s) + " " + markdown.render(campaign.intro).html_safe + markdown.render(campaign.body).html_safe + link_to( t(:join_this_campaign), campaign)
        xml.pubDate campaign.published_at.to_s(:rfc822)
        xml.link "#{APP_CONFIG[:domain]}/campaigns/#{campaign.slug}"
        xml.guid "#{APP_CONFIG[:domain]}/campaigns/#{campaign.slug}"
      end
    end
  end
end
