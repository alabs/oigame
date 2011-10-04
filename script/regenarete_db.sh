#!/bin/sh 

rake db:drop
rake db:create

# Descomentar lineas de active_admin
sed -i '' 's/\(#\)\(.*ActiveAdmin.*\)/\2/' config/routes.rb

rake db:migrate
rake db:data:load

# Copiamos la imagen de la campaña
[[ -d public/uploads/campaign/image/1/ ]] || mkdir public/uploads/campaign/image/1/
cp script/fixtures/* public/uploads/campaign/image/1/

# Comentar lineas de active_admin
sed -i '' 's/.*ActiveAdmin.*/#&/g' config/routes.rb
