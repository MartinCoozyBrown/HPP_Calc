class EcalcsController < ApplicationController
  require 'csv'
  def new
    @ecalc=Ecalc.new
  end

  def create
   #file_data is the file. if it is file, then will use read method. if path with go to path and then use read method 
    file_data=params[:file]
    if file_data.respond_to?(:read)
        xml_contents= file_data.read
    elsif file_data.respond_to?(:path)
      xml_contents= File.read(file_data.path)
    else
        logger.error "bla error"
    end
    csv=CSV.new(xml_contents.to_s, headers: true, header_converters: :all)
    #csv.to_a.map { |row| row.to_hash }
    #converted CSV into an aray of hashes
    csv.each do |row|
    #convert string to date time objects(start and end times)
      row['type']= row['type'].to_string
      row['start_time'] = Chronic.parse("#{row['date']} #{row['start_time']}")
      row['end_time'] = Chronic.parse("#{row['date']} #{row['start_time']}")
      row['usage']= row['usage'].to_string
      row['units']= row['units'].to_string
      row['cost']=row['cost'].to_i
      Ecalc.create row  
    end
  end

  def cost_static
    rate= '.07'
    usagesum=Ecalc.sum('usage')
    cost_static= :rate*:usagesum
  end

  def cost_dynamic
  end




  def edit
  end

  def index
    @ecalc=Ecalc.all
  end

  def import
      Ecalc.import(params[:file])
      redirect_to ecalcs_show_path, notice:"Energy data imported"
  end 

  def ecalc_params
    params.require('ecalc').permit(:file)
  end
end
