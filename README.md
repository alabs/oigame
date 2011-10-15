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

```shell
$ bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )
$ gem install bundler
$ bundle # en la carpeta raíz del proyecto
$ rake db:create
$ rake db:migrate
$ unicorn_rails
```

Entrar en http://localhost:8080

Si quieres crearte un usuario tendrás que comprobar el link que aparecerá en log/development.log

