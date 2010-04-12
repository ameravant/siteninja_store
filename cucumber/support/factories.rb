Factory.define :product do |f|
  f.sequence(:name) { |n| "product#{n}" }
end

Factory.define :product_option do |f|
  options = %w(color size style)
  f.sequence(:name) { |n| "#{options[rand(3)]}#{n}" }
  f.price  rand(30)
  f.available  true
end
