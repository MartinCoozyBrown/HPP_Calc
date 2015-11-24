class Ecalc < ActiveRecord::Base
	has_attached_file :file 
	#CSV.foreach(file.path, headers: true) do |row|
		#Ecalc.create! row.to_hash
	#end
end
