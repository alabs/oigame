# encoding: utf-8
ActiveAdmin.register Campaign do
  
  menu :label => 'Campañas', :priority => 2

  index :title => 'Campañas' do
    column :id
    column :name
    column :moderated
    column :ttype
    column :status
    column 'Creación', :created_at
    column 'Publicación', :published_at
    default_actions
  end

  filter :name
  filter :moderated
  filter :ttype
  filter :status

  before_filter do
    @campaign = Campaign.find_by_slug(params[:id])
  end
end
