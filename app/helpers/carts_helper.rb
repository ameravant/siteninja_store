module CartsHelper
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
end
