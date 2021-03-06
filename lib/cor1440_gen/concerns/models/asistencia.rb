# encoding: UTF-8

module Cor1440Gen
  module Concerns
    module Models
      module Asistencia
        extend ActiveSupport::Concern

        included do
          include Sip::Modelo 

          belongs_to :actividad, class_name: 'Cor1440Gen::Actividad',
            validate: true, foreign_key: 'actividad_id'
          belongs_to :persona, class_name: 'Sip::Persona', validate: true,
            foreign_key: 'persona_id'
          accepts_nested_attributes_for :persona, reject_if: :all_blank
          belongs_to :rangoedadac, class_name: 'Cor1440Gen::Rangoedadac',
            foreign_key: 'rangoedadac_id', optional: true
          belongs_to :orgsocial, class_name: 'Sip::Orgsocial',
            foreign_key: 'orgsocial_id', optional: true
          belongs_to :perfilorgsocial, class_name: 'Sip::Perfilorgsocial',
            foreign_key: 'perfilorgsocial_id', optional: true

          validates :actividad, presence: true
          validates :persona, presence: true

          def evalua_campo(campo, menserr)
            case campo
            when 'persona'
              return self.persona
            else
              menserr = "Campo #{campo} no está en lista blanca de asistencia. "
              puts menserr
              return nil
            end
          end

        end # included
      end
    end
  end
end

