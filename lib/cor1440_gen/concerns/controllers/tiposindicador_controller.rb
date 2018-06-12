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
              "campotind",
              "espvaloresomision",
              "espvalidaciones",
              "espfuncionmedir" ]
          end

          def new
            @registro = clase.constantize.new
            @registro.nombre = 'I'
            @registro.save!(validate: false)
            redirect_to cor1440_gen.edit_tipoindicador_path(@registro)
          end

          # Genero del nombre (F - Femenino, M - Masculino)
          def genclase
            return 'M';
          end

          def tipoindicador_params
            p = *atributos_form + [ :campotind_attributes => [
              :id, :nombrecampo, :tipo, :ayudauso, :_destroy ]
            ]
            params.require(:tipoindicador).permit(p)
          end


        end # included

      end
    end
  end
end

