class SallaryDetailRequirement

	include DataMagic
	DataMagic.load 'sallary_detail_component.yml' 

	def load_component(employeeId)
  		data_for "sallary_detail_component/#{employeeId}"
 	end

end