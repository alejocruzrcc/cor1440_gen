# encoding: utf-8

require_relative '../../test_helper'

module Cor1440Gen
  class ActividadesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Devise::Test::IntegrationHelpers
    
    PRUEBA_ACTIVIDAD ={
      minutos: 45,
      nombre: "nombreact",
      oficina_id: 1,
      fecha: "2014-11-11",
      created_at: "2014-11-11"
    }

    setup do
      @actividad = Actividad.create(PRUEBA_ACTIVIDAD)
      @current_usuario = ::Usuario.create(PRUEBA_USUARIO) 
      sign_in @current_usuario
    end

    test "should get index" do
      get actividades_url
      assert_response :success
    end

    test "should get new" do
      get new_actividad_url
      assert_response :success
    end

    test "should create actividad" do
      assert_difference('Cor1440Gen::Actividad.count') do
        post actividades_url, params: { 
          actividad: PRUEBA_ACTIVIDAD
        }
      end

      assert_redirected_to actividad_url(Cor1440Gen::Actividad.last)
    end

    test "should show actividad" do
      get actividad_url(@actividad)
      assert_response :success
    end

    test "should get edit" do
      get edit_actividad_url(@actividad)
      assert_response :success
    end

    test "should update actividad" do
      patch actividad_url(@actividad), params: { 
        actividad: {  
          nombre: 'otro'
        } 
      }
      assert_redirected_to actividad_url(@actividad)
    end

    test "should destroy actividad" do
      assert_difference('Cor1440Gen::Actividad.count', -1) do
        delete actividad_url(@actividad)
      end

      assert_redirected_to actividades_url
    end
  end
end
