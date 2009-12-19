class StoresController < ApplicationController
  # StoreSearch is not an active record object, so we need to set the attributes (accessors) manually.

  def index
    @products = Product.find(:all)
    unless params[:q].blank?
      zip = params[:q]['zip'].strip
      miles = params[:q]['miles'].strip
      begin
        # Find the zip code entered
        @zip_code = ZipCode.find_by_zip!(zip)
        
        # Find zip codes in the radius
        @zip_codes = ZipCode.radius_search(@zip_code, miles.strip)
        
        @stores = Store.find_all_by_zip(@zip_codes.collect(&:zip))
        
        unless params[:q]['product'].blank?
          @stores = Store.find_all_by_zip(@zip_codes.collect(&:zip), :include => :products, :conditions => ["products.id = ?", params[:q]['product']])
        end
        
        if @stores.empty?
          # No nearby stores found. Try searching again with a larger radius.
          @zip_codes_far = ZipCode.radius_search(@zip_code, 100)
          @stores_far = Store.find_all_by_zip(@zip_codes.collect(&:zip))

          if @stores_far.empty?
            # Still did not find any.
            flash[:error] = "Sorry, but no stores were found. We even tried searching up to 100 miles from your area."
          else
            # Found some further away.
            flash[:notice] = "We did not find any stores in your search radius, but here are some that are farther away."
          end
        end
      rescue ActiveRecord::RecordNotFound
        # Entered zip code was not found in database.
        flash[:error] = "Sorry, but we could not find the zip code #{zip} in our database. Please try again with another zip code in your area."
      end      
    end # check for search
  end

  def show
    @store = Store.find params[:id]
  end
  
 
end
