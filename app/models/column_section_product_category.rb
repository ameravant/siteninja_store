class ColumnSectionProductCategory < ActiveRecord::Base
  belongs_to :column_section
  belongs_to :product_category
  default_scope :order => :sort_order
end
