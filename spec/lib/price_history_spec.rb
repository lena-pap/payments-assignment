# frozen_string_literal: true

require "spec_helper"

RSpec.describe PriceHistory do
  # These tests cover feature request 2. Feel free to add more tests or change
  # the existing ones.

  it "returns the pricing history for the provided year and package" do
    basic = Package.create!(name: "basic")
    stockholm = Municipality.create!(name: "Stockholm")
    gotenborg = Municipality.create!(name: "Göteborg")
    package_price_in_stockholm = PackageMunicipalityPrice.create!(
      package: basic,
      municipality: stockholm,
      price_cents: 1235
    )
    package_price_in_gotenborg = PackageMunicipalityPrice.create!(
      package: basic,
      municipality: gotenborg,
      price_cents: 1234
    )

    travel_to Time.zone.local(2019) do
      # These should NOT be included
      UpdatePackagePrice.call(basic, 20_00, municipality: stockholm.id)
      UpdatePackagePrice.call(basic, 30_00, municipality: gotenborg.id)
    end

    travel_to Time.zone.local(2020) do
      UpdatePackagePrice.call(basic, 30_00, municipality: stockholm.id)
      UpdatePackagePrice.call(basic, 40_00, municipality: stockholm.id)
      UpdatePackagePrice.call(basic, 100_00, municipality: gotenborg.id)
    end

    history = PriceHistory.call(basic, 2020)

    expect(history).to eq(
      "Göteborg" => [100_00],
      "Stockholm" => [30_00, 40_00],
    )
  end

  it "supports filtering on municipality" do
    basic = Package.create!(name: "basic")
    stockholm = Municipality.create!(name: "Stockholm")
    gotenborg = Municipality.create!(name: "Göteborg")
    package_price_in_stockholm = PackageMunicipalityPrice.create!(
      package: basic,
      municipality: stockholm,
      price_cents: 1235
    )
    package_price_in_gotenborg = PackageMunicipalityPrice.create!(
      package: basic,
      municipality: gotenborg,
      price_cents: 1234
    )

    travel_to Time.zone.local(2020) do
      UpdatePackagePrice.call(basic, 30_00, municipality: stockholm.id)
      UpdatePackagePrice.call(basic, 40_00, municipality: stockholm.id)
      UpdatePackagePrice.call(basic, 100_00, municipality: gotenborg.id)
    end

    history = PriceHistory.call(basic, 2020, municipality: stockholm.id)

    expect(history).to eq("Stockholm" => [30_00, 40_00])
  end
end
