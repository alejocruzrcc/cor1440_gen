class AgregaRangoedadacObservaciones < ActiveRecord::Migration[4.2]
  def change
    add_column :cor1440_gen_rangoedadac, :observaciones, :string, limit: 5000, null: true
  end
end
