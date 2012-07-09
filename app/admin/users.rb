ActiveAdmin.register User do
  
  menu :label => 'Usuarios', :priority => 1
  
  index :title => 'Usuarios' do
    column :id
    column :email
    column 'Rol', :role
    column 'Fecha de registro', :created_at
    default_actions
  end
  
  filter :email, :label => 'Email'
  filter :role, :label => 'Rol', :as => :select, :collection => proc { User::ROLES }
end
