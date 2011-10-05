# encoding: utf-8
ActiveAdmin.register Campaign do

  scope :all, :default => true
  scope :published
  scope :not_published

  filter :id
  filter :name
  filter :moderated

  index do
    column "ID" do |c|
      link_to c.id, manage_campaign_path(c)
    end
    column "Nombre" do |c|
      link_to c.name, manage_campaign_path(c)
    end
    column "Imagen" do |c|
      image_tag c.image_url.to_s, :height => "150"
    end
    column "Moderada", :moderated
    default_actions
  end

  member_action :activate, :method => :put do
    campaign = Campaign.find_by_slug(params[:id])
    campaign.activate!
    redirect_to :action => :show, :notice => "Campaña activada"
  end

  controller do
    defaults :finder => :find_by_slug
  end


end
