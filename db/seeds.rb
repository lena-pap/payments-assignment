# frozen_string_literal: true

puts "Removing old packages and their price histories"
Package.destroy_all

puts "Creating new packages"

Package.insert_all(
  YAML.load_file(Rails.root.join("import/packages.yaml"))
)

premium = Package.find_by!(name: "premium")
plus = Package.find_by!(name: "plus")
basic = Package.find_by!(name: "basic")

puts "Creating municipalities"

Municipality.insert_all(
  YAML.load_file(Rails.root.join("import/municipalities.yaml"))
)

stockholm = Municipality.find_by!(name: "Stockholm")
gotenburg = Municipality.find_by!(name: "Göteborg")
malmo = Municipality.find_by!(name: "Malmö")

puts "Creating package prices per municipality"
package_ids = {}
package_ids['premium'] = premium.id
package_ids['plus'] = plus.id
package_ids['basic'] = basic.id

municipality_ids = {}
municipality_ids['Stockholm'] = stockholm.id
municipality_ids['Göteborg'] = gotenburg.id
municipality_ids['Malmö'] = malmo.id

package_prices_per_municipality = YAML.load_file(Rails.root.join("import/package_municipality_prices.yaml"))

package_prices_per_municipality_arr = package_prices_per_municipality.each_with_object([]) do |(key, value), arr|
                                        value.each do |package|
                                          package.each_pair do |name, attrs|
                                            arr << {
                                              municipality_id: municipality_ids[key],
                                              package_id: package_ids[name],
                                              price_cents: attrs['price_cents']
                                            }
                                          end
                                        end
                                      end

PackageMunicipalityPrice.insert_all(package_prices_per_municipality_arr)

puts "Creating a price history for the packages"
prices = YAML.load_file(Rails.root.join("import/initial_price_history.yaml"))

premium.prices.insert_all(prices["premium"])
plus.prices.insert_all(prices["plus"])
basic.prices.insert_all(prices["basic"])
