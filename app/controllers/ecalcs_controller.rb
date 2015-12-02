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
        redirect_to :root
    end
    p file_data
    p xml_contents
    current_user = User.find session[:user_id]
    csv=CSV.new(xml_contents.to_s, headers: true, header_converters: :all)
    #csv.to_a.map { |row| row.to_hash }
    #converted CSV into an aray of hashes
    savings_by_hour =[]
    @energy_usage = 0
    csv.each do |row|
    #convert string to date time objects(start and end times)
      row['type']= row['type'].to_string
      row['start_time'] = Chronic.parse("#{row['date']} #{row['start_time']}")
      row['end_time'] = Chronic.parse("#{row['date']} #{row['start_time']}")
      row['usage']= row['usage'].to_string
      row['units']= row['units'].to_string
      row['cost']=row['cost'].to_i
      #Ecalc.create row  
      usage= Ecalc.new row.to_hash
      usage.user = current_user
      usage.save
      p usage
      p row
      #saving for later use
      @energy_usage += row['usage']
      compare_to = HourlyRate.where time: usage.time, date: usage.date
      #make sure those are the attributes names
      result = usage.usage *compare_to.rate
      #the savings calculation
      savings_by_hour.push result
      #push the result into array for later
    end
    @whatever = current_user.ecalcs.sum('usage')
    p @whatever
  end

  def cost_static
    rate= '.07'
    usagesum=Ecalc.sum('usage')
    cost_static= :rate*:usagesum
  end

  # def cost_dynamic
  #   usage_dynamic= Ecalc.each do |row|
  #     row['start_time'] 
  #     row['usage']
  #     usage_dynamic.save
  #   end
  #   usage_rate= HourlyRate.each do |row|
  #     row['date']
  #     row['time']
  #     row['rate']
  #     usage_rate.save
    #end 
    #cost_dynamic= 
  #end




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
