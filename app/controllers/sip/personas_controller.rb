# encoding: UTF-8
require_dependency "cor1440_gen/concerns/controllers/personas_controller"

module Sip
  class PersonasController < Heb412Gen::ModelosController
    byebug
    include Cor1440Gen::Concerns::Controllers::PersonasController
  end
end
