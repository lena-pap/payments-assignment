class AddToPriceCentsToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :to_price_cents, :integer, null: false
  end
end
