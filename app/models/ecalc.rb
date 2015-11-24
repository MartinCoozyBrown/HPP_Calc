class Ecalc < ActiveRecord::Base
	has_attached_file :file 
	belongs_to :user
	#CSV.foreach(file.path, headers: true) do |row|
		#Ecalc.create! row.to_hash
	#end
end
