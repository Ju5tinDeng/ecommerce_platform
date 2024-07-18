class HomeController < ApplicationController
  def index
    @products = Product.all
  end

  def add_item
    product = Product.find(params[:product_id])

    @cart_item = CartItem.find_or_initialize_by(product: product)
    @cart_item.quantity += params[:quantity].to_i
    if @cart_item.save
      redirect_to root_path, notice: '商品已加入購物車'
    else
      redirect_to root_path, alert: '無法加入購物車'
    end
  end

  def cart
    @cart_items = CartItem.includes(:product).order(updated_at: :desc)
    @total_price = CartItem.total_price(@cart_items)
    @item_desc = CartItem.all.map { |item| "#{item.product.name} x #{item.quantity}" }.join(" ; ")

    @form_info = Newebpay.new.form_info
  end
end