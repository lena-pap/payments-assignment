# frozen_string_literal: true

class Municipality < ApplicationRecord
  has_many :packages, through: :municipalities_packages

  validates :name, presence: true, uniqueness: true
end
