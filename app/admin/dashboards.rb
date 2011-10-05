# encoding: utf-8
ActiveAdmin::Dashboards.build do

  section "Últimas campañas por moderar" do
    table_for Campaign.last_campaigns_moderated do
      column("Nombre")   {|c| link_to(c.name, manage_campaign_path(c)) }
      column("Activar")  {|c| link_to("Activar campaña", activate_manage_campaign_path(c),
                                        :confirm => "Estás seguro que quieres activarla?", :method => :put)}
    end
  end

  section "Últimas campañas publicadas" do
    table_for Campaign.last_campaigns do
      column("Nombre")     {|c| link_to(c.name, manage_campaign_path(c)) }
      column("Publicada")  {|c| c.published_at.to_s }
    end
  end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
