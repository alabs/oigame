oiga.me, Plataforma de movilización ciudadana a través de la web 
=======================================================

oiga.me es una plataforma de acción y movilización ciudadana, una herramienta de democracia participativa a través de sistemas web y correo electrónico para colectivos, entidades o asociaciones que desean ser escuchados. oiga.me multiplica la potencia de miles de pequeños esfuerzos individuales en una poderosa fuerza colectiva. Es, además, un altavoz tecnológico que sirve a personas y organizaciones para hacer oír su voz y constituirse en agente activo en la vida política y social. 

Licencia
========

Mira el fichero LICENSE

Lista de correo
===============

Toda colaboración en bienvenida. Si tienes ganas de participar como desarrollador te animamos a que te suscribas a la lista y nos lo comuniques.

https://listas.alabs.es/mailman/listinfo/oigame-dev

Instalación de entorno de desarrollo
====================================

Instrucciones para Linux y MacOSX

oiga.me necesita ruby 1.9.2, lo mejor es que te instales rvm o rbenv. Para hacerlo con rvm, por 
ejemplo:

```shell
$ bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
```
y luego crea un archivo .rvmrc en la raiz del proyecto, que contenga: "rvm 1.9.2" (sin las comillas)

```shell
$ gem install bundler
$ bundle # en la carpeta raíz del proyecto
$ rake db:create
$ rake db:migrate
$ unicorn_rails
```

Entrar en http://localhost:8080

Para crear un usuario, entra en http://localhost:8080/users/signup, y tras crear el usuario,
necesitas confirmarlo, de momento tendrás que comprobar el link que te aparece en log/development.log
que será algo asi: 
http://localhost:8080/users/confirmation?confirmation_token==3D92V4YYtKeEL5kZfQTGceQ

(recuerda quitar =3D después de confirmation_token=)

