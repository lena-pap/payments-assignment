# frozen_string_literal: true

class PackageMunicipalityPrice < ApplicationRecord
  belongs_to :package
  belongs_to :municipality

  validates :package, uniqueness: { scope: :municipality }
  validates :price_cents, presence: true
end
