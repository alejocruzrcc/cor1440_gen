# encoding: UTF-8

require 'cor1440_gen/concerns/models/respuestafor'
module Mr519Gen
  class Respuestafor < ActiveRecord::Base
    include Cor1440Gen::Concerns::Models::Respuestafor
  end
end
