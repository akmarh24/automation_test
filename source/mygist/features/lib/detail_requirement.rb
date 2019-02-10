class DetailRequirement

	include DataMagic
	DataMagic.load 'component.yml' 

	def load_component(employeeId)
  		data_for "component/#{employeeId}"
 	end

end
