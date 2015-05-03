class AgregaRefUsuarioAActividad < ActiveRecord::Migration
  def change
    add_reference :cor1440_gen_actividad, :usuario, index: true
    add_foreign_key :cor1440_gen_actividad, :usuario 
  end
end
