class ChangePackagePriceToNullable < ActiveRecord::Migration[7.0]
  def up
    change_column :packages, :price_cents, :integer, null: true
  end

  def down
    change_column :packages, :price_cents, :integer, null: false
  end
end
