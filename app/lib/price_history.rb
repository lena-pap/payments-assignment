# frozen_string_literal: true

class PriceHistory
  def self.call(package, year, **options)
    beginning_of_year = DateTime.new(year)
    end_of_year = beginning_of_year.end_of_year
    all_year = beginning_of_year..end_of_year

    prices = package.prices.joins(:municipality).where(created_at: all_year)
    municipality_name = 'municipalities.name'

    if options[:municipality].present?
      prices = prices.where(municipality: { id: options[:municipality] })
      municipality_name = 'municipality.name'
    end

    prices.pluck(municipality_name, :to_price_cents).group_by(&:first).transform_values do |pric|
      pric.transpose.second
    end
  end
end
