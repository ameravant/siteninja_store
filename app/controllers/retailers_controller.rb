class RetailersController < ApplicationController

	def show
		@retailer = Retailer.find params[:id]
	end

end
