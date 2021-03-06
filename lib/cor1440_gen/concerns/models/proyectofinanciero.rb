# encoding: UTF-8

module Cor1440Gen
  module Concerns
    module Models
      module Proyectofinanciero
        extend ActiveSupport::Concern

        included do
          include Sip::Modelo
          include Sip::Localizacion
          include Sip::FormatoFechaHelper
          campofecha_localizado :fechainicio
          campofecha_localizado :fechacierre

          attr_accessor :duracion 

          belongs_to :responsable, class_name: '::Usuario',
            foreign_key: "responsable_id", validate: true, optional: true

          belongs_to :sectorapc, class_name: 'Cor1440Gen::Sectorapc',
            foreign_key: "sectorapc_id", validate: true, optional: true

          has_and_belongs_to_many :actividad, 
            class_name: 'Cor1440Gen::Actividad',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'actividad_id',
            join_table: 'cor1440_gen_actividad_proyectofinanciero'

          has_and_belongs_to_many :beneficiario,
            class_name: 'Sip::Persona',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'persona_id',
            join_table: 'cor1440_gen_beneficiariopf'

          has_and_belongs_to_many :caracterizacion,
            class_name: '::Mr519Gen::Formulario',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'formulario_id',
            join_table: 'cor1440_gen_caracterizacionpf'

          has_and_belongs_to_many :financiador, 
            class_name: 'Cor1440Gen::Financiador',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'financiador_id',
            join_table: 'cor1440_gen_financiador_proyectofinanciero'

          has_and_belongs_to_many :plantillahcm,
            class_name: '::Heb412Gen::Plantillahcm',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'plantillahcm_id',
            join_table: 'cor1440_gen_plantillahcm_proyectofinanciero'

          has_and_belongs_to_many :proyecto, 
            class_name: 'Cor1440Gen::Proyecto',
            foreign_key: 'proyectofinanciero_id',
            association_foreign_key: 'proyecto_id',
            join_table: 'cor1440_gen_proyecto_proyectofinanciero'

          has_many :actividadpf, foreign_key: 'proyectofinanciero_id',
            validate: true, dependent: :destroy, 
            class_name: 'Cor1440Gen::Actividadpf'
          accepts_nested_attributes_for :actividadpf,
            allow_destroy: true, reject_if: :all_blank

          has_many :anexo_proyectofinanciero, dependent: :delete_all,
            class_name: '::Cor1440Gen::AnexoProyectofinanciero',
            foreign_key: 'proyectofinanciero_id', validate: true
          accepts_nested_attributes_for :anexo_proyectofinanciero, 
            allow_destroy: true, reject_if: :all_blank
          has_many :anexo, :through => :anexo_proyectofinanciero, 
            class_name: '::Sip::Anexo'
          accepts_nested_attributes_for :anexo,  reject_if: :all_blank

          has_many :indicadorobjetivo, foreign_key: 'proyectofinanciero_id',
            validate: true, dependent: :destroy, 
            class_name: 'Cor1440Gen::Indicadorpf'
          accepts_nested_attributes_for :indicadorobjetivo,
            allow_destroy: true, reject_if: :all_blank

          has_many :indicadorpf, foreign_key: 'proyectofinanciero_id',
            validate: true, dependent: :destroy, 
            class_name: 'Cor1440Gen::Indicadorpf'
          accepts_nested_attributes_for :indicadorpf,
            allow_destroy: true, reject_if: :all_blank

          has_many :informe, dependent: :delete_all,
            class_name: 'Cor1440Gen::Informe',
            foreign_key: 'filtroproyectofinanciero'

          has_many :mindicadorpf, dependent: :delete_all,
            class_name: 'Cor1440Gen::Mindicadorpf',
            foreign_key: 'proyectofinanciero_id'

          has_many :objetivopf, foreign_key: 'proyectofinanciero_id',
            validate: true, dependent: :destroy, 
            class_name: 'Cor1440Gen::Objetivopf'
          accepts_nested_attributes_for :objetivopf,
            allow_destroy: true, reject_if: :all_blank

          has_many :proyectofinanciero_usuario, dependent: :delete_all,
            class_name: 'Cor1440Gen::ProyectofinancieroUsuario',
            foreign_key: 'proyectofinanciero_id', validate: true
          accepts_nested_attributes_for :proyectofinanciero_usuario, 
            allow_destroy: true#, reject_if: :all_blank
          has_many :usuario, through: :proyectofinanciero_usuario,
            class_name: '::Usuario'

          has_many :resultadopf, foreign_key: 'proyectofinanciero_id',
            validate: true, dependent: :destroy, 
            class_name: 'Cor1440Gen::Resultadopf'
          accepts_nested_attributes_for :resultadopf,
            allow_destroy: true, reject_if: :all_blank


          validates :nombre, presence: true, allow_blank: false, 
            length: { maximum: 1000 } 
          validates :titulo, length: { maximum: 1000 } 
          validates :compromisos, length: { maximum: 5000 }, 
            if: :hay_compromisos?
          def hay_compromisos?
            respond_to?(:compromisos)
          end

          validate :fechas_ordenadas
          def fechas_ordenadas
            if fechainicio && fechacierre && fechainicio > fechacierre
              errors.add(:fechacierre, 
                         "La fecha de cierre debe ser posterior a la de inicio")
            end
          end



          def duracion
            if fechainicio && fechacierre
              Sip::FormatoFechaHelper.dif_meses_dias(fechainicio, fechacierre)
            else
              ''
            end
          end

          # Recibe un grupo de proyectosfinancieros y los filtra 
          # de acuerdo al control de acceso del usuario o a otros parametros
          # recibidos
          def filtra_acceso(current_usuario, pf, params = nil)
            return pf
          end

          scope :filtro_compromisos, lambda { |compromisos|
            where("unaccent(cor1440_gen_proyectofinanciero.compromisos) "\
                  "ILIKE '%' || unaccent(?) || '%'", compromisos.strip)
          }

          scope :filtro_fechainicioini, lambda { |f|
            where('cor1440_gen_proyectofinanciero.fechainicio >= ?', f)
          }

          scope :filtro_fechainiciofin, lambda { |f|
            where('cor1440_gen_proyectofinanciero.fechainicio <= ?', f)
          }

          scope :filtro_fechacierreini, lambda { |f|
            where('cor1440_gen_proyectofinanciero.fechacierre >= ?',  f)
          }

          scope :filtro_fechacierrefin, lambda { |f|
            where('cor1440_gen_proyectofinanciero.fechacierre <= ?', f)
          }

          scope :filtro_financiador_ids, lambda { |f|
            joins(:financiador).
              where('cor1440_gen_financiador.id=?', f)
          }

          scope :filtro_nombre, lambda { |nombre|
            where("unaccent(cor1440_gen_proyectofinanciero.nombre) "\
                  "ILIKE '%' || unaccent(?) || '%'", nombre.strip)
          }

          scope :filtro_observaciones, lambda { |observaciones|
            where("unaccent(cor1440_gen_proyectofinanciero.observaciones) "\
                  "ILIKE '%' || unaccent(?) || '%'", observaciones.strip)
          }

          scope :filtro_proyecto_ids, lambda { |p|
            joins(:proyecto).
              where('cor1440_gen_proyecto.id=?', p)
          }

          scope :filtro_responsable_id, lambda { |r|
            where('cor1440_gen_proyectofinanciero.responsable_id=?', r)
          }

          scope :filtro_titulo, lambda { |titulo|
            where("unaccent(cor1440_gen_proyectofinanciero.titulo) ILIKE '%' "\
                  "|| unaccent(?) || '%'", titulo.strip)
          }


          def presenta(atr)
            case atr.to_s
            when 'proyectofinanciero_usuario', 'equipotrabajo'
              self.proyectofinanciero_usuario.map {|pu|
                pu.usuario ? pu.usuario.nusuario : 'Por contratar'
              }.join('; ')
            else
              presenta_gen(atr)
            end
          end


        end #included
        
        class_methods do

          def human_attribute_name(atr, poromision = "")
            if (atr.to_s == "{:proyecto_ids=>[]}")
              "Proyectos"
            elsif (atr.to_s == "{:financiador_ids=>[]}")
              "Financiadores"
            else
              super(atr)
            end
          end
        end # class_methods

      end
    end
  end
end
