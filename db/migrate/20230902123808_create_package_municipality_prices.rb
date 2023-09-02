class CreatePackageMunicipalityPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :package_municipality_prices do |t|
      t.belongs_to :package
      t.belongs_to :municipality
      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end

    add_index :package_municipality_prices, [:municipality_id, :package_id], unique: true,
              name: 'idx_packag_municipality_prices_on_municipality_id_and_packag_id'
  end
end
