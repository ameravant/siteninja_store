class Admin::StoresController < AdminController
  before_filter :find_store, :only => [ :edit, :update, :destroy ]
  before_filter :find_retailers_and_products, :only => [ :edit, :new ]
  add_breadcrumb "Stores"
  
  require 'fastercsv'
  require 'csv'
  
  def index
    if params[:q].blank?
      @all_stores = Store.all
    else
      @all_stores = Store.find :all,
        :conditions => ["name like ? or city like ? or state like ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%"]
    end
    @stores = @all_stores.paginate(:page => params[:page], :per_page => 50)
  end
  
  def edit
  end
  
  def new
    @store = Store.new
  end
  
  def update
    if @store.update_attributes params[:store]
      flash[:notice] = "#{@store.name} has been updated."
      redirect_to admin_stores_path
    else
      render :action => "edit"
    end
  end
  
  def create
    @store = Store.new params[:store]
    if @store.save
      flash[:notice] = "#{@store.name} has been created."
      redirect_to admin_stores_path
    else
      render :action => "new"
    end
  end
  
  def destroy
    @store.destroy
    respond_to :js
  end
  
  def csv
    
  end
  
  def csv_import 
		#Set variables before loop
		n = 0 #Number of Successful Imports
		new_stores = 0 #Number of New Stores
		updated_stores = 0 #Number of Updated Stores
		failed = 0 #Number of records failing for any reason
		new_store = false #Set to false by default 

		@parsed_file=CSV::Reader.parse(params[:dump][:file])
		@parsed_file.each  do |row|
			
			s = Store.find(:first, :conditions => {:address => row[2], :city => row[4], :state => row[5]})
			new_store = true if s.blank?
			s = Store.new if s.blank?
			s.store_type = row[0]
			s.name = row[1]
			s.address = row[2]
			s.address2 = row[3]
			s.city = row[4]
			s.state = row[5]
			s.zip = row[6]
			s.country = row[7]
			s.phone = row[8]
			s.fax = row[9]
			s.email = row[10]
			s.website = row[11]
			s.contact_name = row[12]
			s.contact_position = row[13]
			
			retailer_search = row[1].split(' ').slice(0,2).join(' ')
			r = Retailer.find(:first, :conditions => ["name like ?", "%#{retailer_search}%"])
			if r.blank?
			  r = Retailer.new
			  r.name = row[1]
			  r.save
			end
			
			s.retailer_id = r.id
			
			products = []
			product_array = row[26].split(";") unless row[26].blank?
			unless product_array.blank?
			  for product in product_array
			    p = Product.find_by_import_name(product)
			    if p.blank?
			      p = Product.new
			      p.name = product
			      p.import_name = product
			      p.save
			    end
			    products << p
			  end
		  end
		  
			s.product_ids=[products]
			
			if s.save
				n=n+1
				GC.start if n%50==0
				new_stores = new_stores + 1 if new_store
				updated_stores = updated_stores + 1 unless new_store
			else
				failed = failed + 1
			end
			products = 0
		
		end
		flash[:notice]="CSV Import Successful. #{n} successful records, #{new_stores} new records added, #{updated_stores} records updated, #{failed} imports failed."
		redirect_to admin_stores_path
	end
  
  private
  
  def find_store
    @store = Store.find params[:id]
  end
  
  def find_retailers_and_products
  	@retailers = Retailer.find(:all, :conditions => {:featured => true})
  	@products = Product.find(:all)
  end
end
