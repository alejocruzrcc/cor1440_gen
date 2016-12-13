# encoding: UTF-8
module Cor1440Gen
  module Admin
    class ProyectosfinancierosController < Sip::Admin::BasicasController
      before_action :set_proyectofinanciero, 
        only: [:show, :edit, :update, :destroy]
      load_and_authorize_resource  class: Cor1440Gen::Proyectofinanciero

      def clase 
        "Cor1440Gen::Proyectofinanciero"
      end

      def set_proyectofinanciero
        @basica = Proyectofinanciero.find(params[:id])
      end

      def atributos_index
        [ "id", 
          "nombre" ] +
        [ :financiador_ids =>  [] ] +
        [ "fechainicio_localizada",
          "fechacierre_localizada",
          "responsable_id"
        ] +
        [ :proyecto_ids =>  [] ] +
        [ "compromisos", 
          "monto",
          "observaciones"
        ] 
      end

      # Genero del nombre (F - Femenino, M - Masculino)
      def genclase
        return 'M';
      end

      def proyectofinanciero_params
        params.require(:proyectofinanciero).permit(*atributos_form)
      end

    end
  end
end
