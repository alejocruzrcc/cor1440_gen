# encoding: UTF-8

module Cor1440Gen
  module Concerns
    module Controllers
      module TiposindicadorController
        extend ActiveSupport::Concern

        included do
          before_action :set_tipoindicador, 
            only: [:show, :edit, :update, :destroy]
          load_and_authorize_resource  class: Cor1440Gen::Tipoindicador

          include Sip::FormatoFechaHelper

          def clase 
            "Cor1440Gen::Tipoindicador"
          end

          def new_modelo_path(o)
            return new_tipoindicador_path()
          end

          def set_tipoindicador
            @registro = Tipoindicador.find(params[:id])
          end

          def atributos_index
            [ "id", 
              "nombre",
              "medircon",
              "esptipometa",
              "espcampos",
              "espvaloresomision",
              "espvalidaciones",
              "espfuncionmedir" ]
          end

          # Genero del nombre (F - Femenino, M - Masculino)
          def genclase
            return 'M';
          end

          def tipoindicador_params
            params.require(:tipoindicador).permit(*atributos_form)
          end


        end # included

      end
    end
  end
end

