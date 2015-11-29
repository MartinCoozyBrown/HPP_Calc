# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
require 'chronic'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'HourlyRate.OCT.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
	row['date'] = Chronic.parse("#{row['date']}")
	row['time'] = Chronic.parse("#{row['time']}")
	row['rate'] = row['rate'].to_f
	HourlyRate.create row
	puts row.to_hash
end

