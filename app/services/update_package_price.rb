# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    Package.transaction do
      price_for_municipality = package.price_for(options[:municipality]) if options[:municipality].present?

      # Add a pricing history record
      Price.create!(
        package: package,
        price_cents: price_for_municipality&.price_cents || package.price_cents,
        municipality: price_for_municipality&.municipality
      )

      # Update the current price
      package.update!(price_cents: new_price_cents)
      # Update the current price for municipality
      price_for_municipality.update!(price_cents: new_price_cents) if options[:municipality].present?
    end
  end
end
