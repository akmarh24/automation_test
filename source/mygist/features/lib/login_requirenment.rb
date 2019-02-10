class LoginRequirenment

	include DataMagic
	DataMagic.load 'secrets.yml' 

	def load_user(user_details)
  		data_for "secrets/#{user_details}"
 	end

end