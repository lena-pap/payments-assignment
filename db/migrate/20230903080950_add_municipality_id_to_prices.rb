class AddMunicipalityIdToPrices < ActiveRecord::Migration[7.0]
  def change
    add_reference :prices, :municipality, null: true, foreign_key: true
  end
end
