resources :stores, :cart_items, :shipping_addresses, :billing_addresses, :orders, :retailers
resources :products, :as => products_path, :has_many => [ :images, :testimonials ], :member => { :add_to_cart => :put }
resources :product_categories
resources :checkouts
resource :cart

namespace :admin do |admin|
  #admin.resources :orders, :shipping_methods, :retailers
  admin.resources :product_categories, :collection => { :reorder => :put }, :member => { :reorder => :put }
  admin.resources :stores, :collection => { :csv_import => :post, :import => :get }
  admin.resources :locations

  admin.resources :products, :has_many => :features do |product|
      product.resources :images, :collection => { :reorder => :put, :add_multiple => :get }
      product.resources :testimonials
    end
end

store '/store', :controller => 'products'
products '/products', :controller => 'products'
shipping '/shipping', :controller => "shipping_addresses", :action => "new"
billing '/billing', :controller => "billing_addresses", :action => "new"
checkout '/checkout', :controller => "orders", :action => "new"

