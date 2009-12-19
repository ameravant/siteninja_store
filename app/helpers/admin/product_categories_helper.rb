module Admin::ProductCategoriesHelper
  def build_tree(parent_id=nil)
    children = @product_categories.select { |tree_category| tree_category.parent_id == parent_id }
    ul_id = "tree_#{parent_id || '0'}"
    unless children.empty?
      concat "<ul id=\"#{ul_id}\" class=\"sortable\">\n"

      # Output the list elements for these children, and recursively
      # call build_menu for their children.
      for child in children
        concat "<li id=\"#{dom_id child}\" style=\"border-top: #ccc 1px solid; \">" + '<div class="category-title">'
        concat image_tag("#{move_loc}", :class => "icon handle", :alt => "handle") + ' ' if children.size > 1
        concat link_to(h(child.title), [:edit, :admin, child])
        concat '</div><div class="category-options">'
        unless child.permalink == "categories"
          concat ' ' + icon("Write", edit_admin_product_category_path(child))
          concat ' ' + trash_icon(child, admin_product_category_path(child), "#{child.title}")
        else
          concat ' ' + "<div style='width: 44px; height: 4px; float: right;'></div>"
        end
        concat '</div><div class="category-assets">'
        concat "</div>" + clear
        build_tree(child.id)
        concat "</li>\n"
      end
      concat "</ul>\n"

      # Make this list sortable if more than 1 child is listed
      if children.size > 1
        concat sortable_element(ul_id,
          :url => reorder_admin_product_categories_path + "?product_category_id=#{(parent_id || 0)}",
          :method => :put,
          :loading => "$('ajax_spinner').src='#{spinner_loc}'; $('reorder_status').show();",
          :success => "$('ajax_spinner').src='#{ok_loc}'",
          :failure => "$('ajax_spinner').src='#{exclamation_loc}'",
          :complete => visual_effect(:fade, "reorder_status", :delay => 1)
        )
      end
    end
  end
end
