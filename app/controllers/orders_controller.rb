class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:notify]

  def notify
    response = NewebpayResponse.new(params[:TradeInfo]).response

    if response["Status"] != "SUCCESS"
      redirect_to root_path, notice: '付款失敗'
    else
      response = response["Result"]
      Order.create!(order_number: response["MerchantOrderNo"], total_price: response["Amt"])
      order = Order.find_by(order_number: response["MerchantOrderNo"])
      @cart_items = CartItem.all
      @cart_items.each do |cart_item|
        OrderItem.create!(
          order: order,
          product_name: cart_item.product.name,
          product_quantity: cart_item.quantity,
          unit_price: cart_item.product.unit_price,
          subtotal_price: cart_item.quantity * cart_item.product.unit_price
        )
      end
      @cart_items.destroy_all
      redirect_to root_path, notice: '付款成功，訂單已建立'
    end
    rescue ActiveRecord::RecordInvalid => e
      redirect_to root_path, alert: "訂單建立失敗: #{e.message}"
  end
end