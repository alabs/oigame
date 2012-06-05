xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "oiga.me"
    xml.description "Plataforma para la creación de campañas sociales"
    xml.link "#{APP_CONFIG[:domain]}/"

    @campaigns.each do |campaign|
      xml.item do
        xml.title campaign.name
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
          :autolink => true, :space_after_headers => true)
        xml.description markdown.render(campaign.intro).html_safe + "<p>> " + link_to('Únete a esta campaña', campaign) + "</p>"
        xml.pubDate campaign.published_at.to_s(:rfc822)
        xml.link "#{APP_CONFIG[:domain]}/campaigns/#{campaign.slug}"
        xml.guid "#{APP_CONFIG[:domain]}/campaigns/#{campaign.slug}"
      end
    end
  end
end
