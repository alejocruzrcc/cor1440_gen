# encoding: UTF-8

module Cor1440Gen
  module Concerns
    module Controllers
      module ProyectosfinancierosController
        extend ActiveSupport::Concern

        included do
          before_action :set_proyectofinanciero, 
            only: [:show, :edit, :update, :destroy]
          load_and_authorize_resource  class: Cor1440Gen::Proyectofinanciero,
            except: :actividadespf

          include Sip::FormatoFechaHelper

          def clase 
            "Cor1440Gen::Proyectofinanciero"
          end

          def new_modelo_path(o)
            return new_proyectofinanciero_path()
          end

          def set_proyectofinanciero
            @registro = Proyectofinanciero.find(params[:id])
          end

          # Redefinimos destroy porque el de tablas basicas 
          # (i.e Sip::Admin::BasicasController que debe ser
          # papa de la clase que incluye a esta)
          # exije eliminar primero registros en tablas union
          def destroy
            authorize! :destroy, Cor1440Gen::Proyectofinanciero
            super("", false)
          end

          def atributos_index
            [ 
              :id, 
              :nombre 
            ] +
            [ :financiador_ids =>  [] ] +
            [ 
              :fechainicio_localizada,
              :fechacierre_localizada,
              :responsable
            ] +
            [ :proyecto_ids =>  [] ] +
            [ :compromisos, 
              :monto, 
              :observaciones, 
              :objetivopf,
              :indicadorobjetivo,
              :resultadopf,
              :indicadorpf,
              :actividadpf 
            ]
          end

          # Genero del nombre (F - Femenino, M - Masculino)
          def genclase
            return 'M';
          end

          def index(c = nil)
            authorize! :read, Cor1440Gen::Proyectofinanciero
            if c == nil
              c = Cor1440Gen::Proyectofinanciero.all
            end
            if params[:fecha] && params[:fecha] != ''
              fecha = fecha_local_estandar params[:fecha]
              c = c.where('fechainicio <= ? AND ' +
                          '(? <= fechacierre OR fechacierre IS NULL) ', 
                          fecha, fecha)
            end
            super(c)
          end  

          def actividadespf
            authorize! :read, Cor1440Gen::Proyectofinanciero
            pfl = []
            if params[:pfl] && params[:pfl] != ''
              params[:pfl].each do |pf|
                pfl << pf.to_i
              end
            end
            c = Cor1440Gen::Actividadpf.where(proyectofinanciero_id: pfl)
            respond_to do |format|
              format.json {
                @registros = @registro = c.all
                render :actividadespf#, json: @registro
                return
              }
              format.js {
                @registros = @registro = c.all
                render :actividadespf#, json: @registro
              }
              format.html {
                render inline: @registros.errors, 
                status: :unprocessable_entity
              }
            end
          end

          def objetivospf
            authorize! :read, Cor1440Gen::Proyectofinanciero
            pfl = []
            if params[:pfl] && params[:pfl] != ''
              params[:pfl].each do |pf|
                pfl << pf.to_i
              end
            end
            c = Cor1440Gen::Objetivopf.where(proyectofinanciero_id: pfl)
            respond_to do |format|
              format.json {
                @registros = @registro = c.all
                render :objetivospf
                return
              }
              format.js {
                @registros = @registro = c.all
                render :objetivospf
              }
              format.html {
                render inline: @registros.errors, 
                status: :unprocessable_entity
              }
            end
          end

          def new
            authorize! :new, Cor1440Gen::Proyectofinanciero
            @registro = clase.constantize.new
            @registro.monto = 1
            @registro.nombre = 'N'
            @registro.save!
            redirect_to cor1440_gen.edit_proyectofinanciero_path(@registro)
          end


          def proyectofinanciero_params
            params.require(:proyectofinanciero).permit(
              atributos_show +
              [ 
                :objetivopf_attributes =>  [
                  :id, :numero, :objetivo, :_destroy ] 
              ] +
              [
                :indicadorobjetivo_attributes =>  [
                  :id, :objetivopf_id,
                  :numero, :indicador, 
                  :tipoindicador_id, :_destroy ] 
              ] +
              [ :resultadopf_attributes =>  [
                :id, :objetivopf_id,
                :numero, :resultado, :_destroy ] 
              ] +
              [ :indicadorpf_attributes =>  [
                :id, :resultadopf_id,
                :numero, :indicador, :tipoindicador_id,
                :_destroy ] 
              ] +
              [ :actividadpf_attributes =>  [
                :id, :resultadopf_id,
                :actividadtipo_id,
                :nombrecorto, :titulo, 
                :descripcion, :_destroy ] 
              ] )
          end



        end # included

      end
    end
  end
end

