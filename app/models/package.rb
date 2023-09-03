# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :package_municipality_prices
  has_many :municipalities, through: :package_municipality_price

  validates :name, presence: true, uniqueness: true

  def price_for(municipality_id)
    package_municipality_prices.find_by(municipality_id: municipality_id)
  end
end
