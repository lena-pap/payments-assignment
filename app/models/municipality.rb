# frozen_string_literal: true

class Municipality < ApplicationRecord
  has_many :packages, through: :package_municipality_price

  validates :name, presence: true, uniqueness: true
end
