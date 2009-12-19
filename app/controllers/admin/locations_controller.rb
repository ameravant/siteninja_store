class Admin::LocationsController < AdminController
  before_filter :find_location, :only => [:edit, :update, :destroy]
  add_breadcrumb "Products", "admin_products_path"
  add_breadcrumb "Locations", nil  
  
  def index
    @locations = Location.all
  end

  def new
    @location = location.new
    @locations = location.find(:all, :conditions => ["id != ?", @location.id])
  end
  
  def edit

  end
  
  def destroy
    if @location.destroy
      flash[:notice] = "#{@location.name} deleted."
      redirect_to admin_locations_path
    end
  end
  
  def create
    @location = location.new(params[:location])
    if @location.save
      flash[:notice] = "#{@location.name} created."
      redirect_to admin_locations_path
    else
      render :action => "new"
    end
  end
  
  def update
    if @location.update_attributes(params[:location])
      flash[:notice] = "#{@location.name} updated."
      redirect_to admin_locations_path
    else
      render :action => "edit"
    end
  end
  private
    def find_location
      @location = Location.find(params[:id])
    end
end
