# encoding: utf-8
ActiveAdmin.register AdminUser do
  
  filter :id
  filter :email

  index do
    column "ID" do |u|
      link_to u.id, manage_admin_user_path(u)
    end
    column "Email" do |u|
      link_to u.email, manage_admin_user_path(u)
    end
    column "Última conexión", :last_sign_in_ip
    column "Último login", :last_sign_in_at
    default_actions
  end

  form do |f|
    f.inputs "Crear nuevo admin" do
      f.input :email
    end
    f.buttons
  end
end
