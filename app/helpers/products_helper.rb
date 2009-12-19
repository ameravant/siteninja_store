module ProductsHelper
  
  def real_price(product)
    unless product.price.blank?
      if product.sale_price.blank?
        concat "Price: #{number_to_currency(product.price)}"
      else
        spans = []
        spans << content_tag("span", "Price: #{number_to_currency(product.price)}", :class => "regular-price")
        spans << content_tag("span", "<br />Sale Price: #{number_to_currency(product.sale_price)}", :class => "sale-price")
        concat content_tag("div", spans.join(' '), :class => "product-price")
      end
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
  
  def build_name(id, name)
    pc = ProductCategory.find_by_id(id)
    unless pc.parent_id.blank?
      parent = ProductCategory.find_by_id(self.parent_id)
      name = "#{parent.name} &mdash; #{name}"
      build_name(parent.id, name)
    else
      name
    end
  end
  
end
