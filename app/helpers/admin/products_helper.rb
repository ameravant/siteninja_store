module Admin::ProductsHelper


  def real_price(product)
    if product.sale_price.blank?
      concat number_to_currency(product.price)
    else
      spans = []
      spans << content_tag("span", "#{number_to_currency(product.price)}", :class => "strike")
      spans << content_tag("span", "<br />On Sale! #{number_to_currency(product.sale_price)}", :class => "sale_price")
      concat content_tag("div", spans.join(' '))
    end
  end


  
  def build_children(parent_id=nil)
    pc = ProductCategory.all
    children = pc.select { |tree_category| tree_category.parent_id == parent_id }
    unless children.empty?
      concat "<ul>\n"
      # Output the list elements for these children, and recursively
      # call build_menu for their children.
      for child in children
        concat "<li>" + link_to(h(child.title), child) + "</li>"
        build_children(child.id)
      end
      concat "</ul>\n"
    end
  end
  
  def build_form_children(parent_id, product)
    pc = ProductCategory.all
    children = pc.select { |tree_category| tree_category.parent_id == parent_id }
    unless children.empty?
      concat "<ul>\n"
      # Output the list elements for these children, and recursively
      # call build_menu for their children.
      for child in children
        concat "<li>" + "<label for=\"#{dom_id(child)}\">#{child.name}</label>" + check_box_tag("product[product_category_ids][]", child.id, product.product_categories.include?(child), :id => dom_id(child)) + clear + "</li>"
        build_form_children(child.id, product)        
      end
      concat "</ul>\n"
    end
  end
  
  def build_name(id, name)
    pc = ProductCategory.find_by_id(id)
    unless pc.parent_id.blank?
      parent = ProductCategory.find_by_id(pc.parent_id)
      name = "#{parent.name} &mdash; #{name}"
      build_name(parent.id, name)
    else
      name
    end
  end
  
  def fields_for_product_option(product_option, &block)
    prefix = product_option.new_record? ? "new" : "existing"
    fields_for("product[#{prefix}_product_options][]", product_option, &block)
  end

  def add_product_option_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :product_options, :partial => 'product_option', :object => ProductOption.new 
    end 
  end
  
end
