# encoding: UTF-8
require_dependency "sip/application_controller"

module Cor1440Gen
  class ActividadesController < ApplicationController
    before_action :set_actividad, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource class: Cor1440Gen::Actividad

    # GET /actividades
    # GET /actividades.json
    def index
      @actividades = Actividad.order(fecha: :desc).paginate(
        :page => params[:pagina], per_page: 20)
        render "index", layout: "application"
    end

    # GET /actividades/1
    # GET /actividades/1.json
    def show
      render layout: "application"
    end

    # GET /actividades/new
    def new
      @actividad = Actividad.new
      @actividad.current_usuario = current_usuario
      #@actividad.oficina_id = current_usuario.oficina_id ?  current_usuario.oficina_id : 1
      @actividad.oficina_id = 1
      render layout: "application"
    end

    # GET /actividades/1/edit
    def edit
      render layout: "application"
    end

    # POST /actividades
    # POST /actividades.json
    def create
      @actividad = Actividad.new(actividad_params)
      @actividad.current_usuario = current_usuario
      respond_to do |format|
        if @actividad.save
          format.html { redirect_to @actividad, notice: 'Actividad creada.' }
          format.json { 
            render action: 'show', status: :created, location: @actividad 
          }
        else
          format.html { render action: 'new', layout: 'application' }
          format.json { 
            render json: @actividad.errors, status: :unprocessable_entity 
          }
        end
      end
    end

    # PATCH/PUT /actividades/1
    # PATCH/PUT /actividades/1.json
    def update
      respond_to do |format|
        if @actividad.update(actividad_params)
          format.html { 
            redirect_to @actividad, notice: 'Actividad actualizada.' 
          }
          format.json { head :no_content }
        else
          format.html { render action: 'edit', layout: 'application' }
          format.json { 
            render json: @actividad.errors, status: :unprocessable_entity 
          }
        end
      end
    end

    # DELETE /actividades/1
    # DELETE /actividades/1.json
    def destroy
      @actividad.destroy
      respond_to do |format|
        format.html { 
          redirect_to actividades_url, notice: 'Actividad eliminada' }
          format.json { head :no_content }
      end
    end

    private

    def set_actividad
      @actividad = Actividad.find(
        Actividad.connection.quote_string(params[:id]).to_i
      )
      @actividad.current_usuario = current_usuario
    end

    # No confiar parametros a Internet, sólo permitir lista blanca
    def actividad_params
      params.require(:actividad).permit(
        :oficina_id, :minutos, :nombre, 
        :objetivo, :proyecto, :resultado,
        :fecha, :actividad, :observaciones, 
        :usuario_id,
        :actividadarea_ids => [],
        :actividadtipo_ids => [],
        :proyecto_ids => [],
        :actividad_rangoedadac_attributes => [
          :id, :rangoedadac_id, :fl, :fr, :ml, :mr, :_destroy
      ],
        :actividad_sip_anexo_attributes => [
          :id,
          :id_actividad, 
          :_destroy,
          :sip_anexo_attributes => [
            :id, :descripcion, :adjunto, :_destroy
      ]
      ]
      )
    end
  end
end
