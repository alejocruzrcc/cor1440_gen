# cor1440_gen : Motor para planeación y seguimiento de actividades e informes en una ONG
[![Estado Construcción](https://api.travis-ci.org/pasosdeJesus/cor1440_gen.svg?branch=master)](https://travis-ci.org/pasosdeJesus/cor1440_gen) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/cor1440_gen/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/cor1440_gen) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/cor1440_gen/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/cor1440_gen) [![security](https://hakiri.io/github/pasosdeJesus/cor1440_gen/master.svg)](https://hakiri.io/github/pasosdeJesus/cor1440_gen/master) [![Dependencias](https://gemnasium.com/pasosdeJesus/cor1440_gen.svg)](https://gemnasium.com/pasosdeJesus/cor1440_gen) 


## Tabla de Contenido
* [Diseño](#diseño)
* [Uso](#uso)
* [Pruebas](#pruebas)
* [Desarrollo](#pruebas)

Este es un motor para un sistema de información que facilite la planeación y el seguimiento de actividades en una ONG, que opera sobre Ruby on Rails 4.2 y
PostgreSQL (preferiblemente cifrado como en adJ).

Este motor incluye 
* Uso del motor sip (que a su vez maneja devise, cancancan, rspec, tablas básicas con datos geográficos para varios paises, manejo de anexos con paperclip, facilidades de configuracion como puede ver en https://github.com/pasosdeJesus/sip)
* 
* Roles con cancancan, 
* Pruebas con rspec y factory girl,
* Propuesta para manejar tablas básicas (parámetros de la aplicación) y esqueletos 
  para: paises, departamentos/estados, municipios, centros poblados, tipos de 
  centros poblados, tipos de sitios, ubicaciones, tipos de relaciones entre 
  personas, tipos de documentos de identificación, oficinas.  Faciles de 
  modificar en aplicaciones que usen el motor vía ActiveSupport::Cocern.
* Datos geográficos completos para Colombia y Venezuela.
* Propuesta de estructura para otros modelos típicos persona, anexo, también 
  modificables en aplicación que use el motor via ActiveSupport::Concern.
* Manejo de anexos con paperclip 
* Facilidades de configuración en lib/sip/engine.rb, como inclusión automática 
  de sus migraciones en las aplicaciones que usen el motor y variables típicas 
  de configuración.
* Tareas rake para actualizar indices, sacar copia de respaldo de base de datos
* Generador de nuevas tablas básicas
* Aplicación de prueba completa en spec/dummy con diseño adaptable (responsive) 
  usando bootstrap, simple_form y jquery que permite modificar las tablas 
  básicas paginando con will_paginate

## Diseño

Se ha extraido de las partes comunes de diversos sistemas de información,
particularmente de SIVeL 2, Cor440 y Sal7711.

Roles: administrador y usuario

## Uso

### Requerimientos
* Ruby version >= 2.1
* PostgreSQL >= 9.3 con extensión unaccent disponible
* Recomendado sobre adJ 5.6 (que incluye todos los componentes mencionados).  
  Las siguientes instrucciones suponen que opera en este ambiente.


## Pruebas
Se han implementado algunas pruebas con RSpec a modelos y pruebas de regresión.

* Instale gemas requeridas (como Rails 4.2) con:
``` sh
  cd spec/dummy
  bundle install
```
Aunque para minimizar descargas vale la pena instalar como gemas del
sistema la mayoría de estas, en adJ con:
```sh
  grep "^ *gem" Gemfile | sed -e "s/gem [\"']//g;s/[\"'].*//g" | xargs sudo NOKOGIRI_USE_SYSTEM_LIBRARIES=1 make=gmake gem install
```
* Cree usuario para PostgreSQL (recomendado sipdes o el que especifique en 
  config/database.yml) y pongale una clave, por ejemplo en adJ
```sh
sudo su - _postgresql
$ createuser -Upostgres -h/var/www/tmp -s sipdes
$ psql -h/var/www/tmp -Upostgres
psql (9.3.5)
Type "help" for help.

postgres=# ALTER USER sipdes WITH password 'miclave';
ALTER ROLE
postgres=# \q
$ exit
```
* Prepare spec/dummy/config/database.yml con los datos de la base que creo:
```sh
  cp spec/dummy/config/database.yml.plantilla spec/dummy/config/database.yml
  vim spec/dummy/config/database.yml
```
* Prepare base de prueba con:
``` sh
  cd spec/dummy
  RAILS_ENV=test rake db:drop
  RAILS_ENV=test rake db:setup
  RAILS_ENV=test rake sip:indices
```
* Ejecute las pruebas desde el directorio del motor con:
```sh
  rspec
```

## Aplicación de prueba

Si ya configuró usuario paa la base de datos, puede iniciar la 
aplicación de prueba con:
```sh
  cd spec/dummy
  rake db:drop db:setup sip:indices
  rails s -b 127.0.0.1 -p 3000
```
y examinar desde el mismo computador con un navegador en: 
http://127.0.0.1:3000 

Puede ingresar con usuario sip y clave sip123 para
interactuar con el manejo de usuarios y 

## Desarrollo

Si tiene instalado coffescript, podrá verificar sintaxis de archivos del 
directorio app/assets/javascript/ con:
```sh
  make
```

### Convenciones

2 espacios de indentación.

Para configurarlo en vim, agregue al final de ```~/.vim/ftplugin/ruby.vim```:
``` vim
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
```

http://betterspecs.org/
http://www.caliban.org/ruby/rubyguide.shtml
https://hakiri.io/blog/ruby-security-tools-and-resources

### Generación de datos de tablas básicas

Una vez estén bien los datos de tablas básicas en base de datos de la
la aplicación de  prueba spec/dummy:
```sh
cd spec/dummy
RAILS_ENV=test rake sip:vuelcabasicas
cp db/datos-basicas.sql ../../db/datos-basicas.sql
```

