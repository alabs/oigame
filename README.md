[![oiga.me](https://oiga.me/assets/logo-small.png "oiga.me")](https://oiga.me)

[![Build Status](https://secure.travis-ci.org/alabs/oigame.png)](http://travis-ci.org/alabs/oigame)

# oiga.me

### Plataforma de movilización ciudadana a través de la web 

oiga.me es una plataforma de acción y movilización ciudadana, una herramienta de democracia participativa a través de sistemas web y correo electrónico para colectivos, entidades o asociaciones que desean ser escuchados. oiga.me multiplica la potencia de miles de pequeños esfuerzos individuales en una poderosa fuerza colectiva. Es, además, un altavoz tecnológico que sirve a personas y organizaciones para hacer oír su voz y constituirse en agente activo en la vida política y social. 

## Licencia

Mira el fichero LICENSE

## Lista de correo

Toda colaboración en bienvenida. Si tienes ganas de participar como desarrollador te animamos a que te suscribas a la lista y nos lo comuniques.

https://listas.alabs.es/mailman/listinfo/oigame-dev

## Instalación de entorno de desarrollo

Instrucciones para Linux y MacOSX

oiga.me necesita ruby 1.9, lo mejor es que te instales rvm o rbenv. Para hacerlo con rvm, por 
ejemplo:

```shell
$ curl -L https://get.rvm.io | bash -s stable --ruby
```

```shell
$ gem install bundler
$ bundle # en la carpeta raíz del proyecto
$ bundle exec rake db:create
$ bundle exec rake db:migrate
$ bundle exec thin start -p 8080
```

Se necesitan las siguientes dependencias: 

sudo aptitude install libmysqlclient-dev libmagick-dev libmagickwand-dev


## Traducciones

Para manejar las traducciones utilizamos tolk: 

https://github.com/tolk/tolk

El acceso a la interfaz administrativa es a través de /translate. Esto deja las traducciones en la base de datos, pudiendo exportarla a los ficheros de config/locales/*.yml con el comando: 

```shell
$ rake tolk:dump_all
```

Otra acción común a realizar es sincronizar los cambios en estos ficheros con los de la base de datos, por ejemplo al agregar nuevas cadenas o modificar antiguas en el locale por defecto (config/locales/es.yml).

```shell
$ rake tolk:sync
```

Para facilitar la traducción a personas externas del proyecto, se ha creado un usuario en https://beta.oiga.me con las siguientes credenciales: 

* user: beta@oiga.me
* pass: emagio

Por lo que las personas externas pueden traducir iniciando sesión en https://beta.oiga.me/translate 

## Resque 

Para las tareas asíncronas utilizamos Resque. Para que funcione es necesario tener instalado y corriendo el servidor de redis

```shell
$ sudo aptitude install redis-server
```

Una vez esté levantado hay que levantar los workers del resque.

```shell
$ QUEUE=* rake resque:work
```
