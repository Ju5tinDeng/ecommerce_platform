class CartItem < ApplicationRecord
  belongs_to :product

  def self.total_price(cart_items)
    cart_items.sum { |item| item.product.unit_price * item.quantity }
  end
end
