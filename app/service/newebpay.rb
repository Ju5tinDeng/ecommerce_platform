class Newebpay
  attr_accessor :info
  
  def initialize
    @key = ENV["HASH_KEY"]
    @iv = ENV["HASH_IV"]
    @merchant_id = ENV["MERCHANT_ID"]
    @info = {}
    
    @merchant_order_no = Time.now.strftime("%Y%m%d%H%M%S")
    @cart_items = CartItem.includes(:product)
    @total_price = CartItem.total_price(@cart_items).ceil
    @item_desc = CartItem.all.map { |item| "#{item.product.name} x #{item.quantity}" }.join(" ; ")
    
    set_info
  end

  def set_info
    info[:MerchantID] = @merchant_id
    info[:RespondType] = "JSON"
    info[:TimeStamp] = Time.now.to_i 
    info[:Version] = "2.0"
    info[:MerchantOrderNo] = @merchant_order_no
    info[:Amt] = @total_price
    info[:ItemDesc] = @item_desc
    info[:ReturnURL] = ''
  end

  def encoded_info
    URI.encode_www_form(info)
  end

  def trade_info
    encrypt(encoded_info)
  end
  
  def trade_sha
    generate_aes_sha256(@key, @iv, trade_info)
  end

  def form_info
    {
      MerchantID: @merchant_id,
      TradeInfo: trade_info,
      TradeSha: trade_sha,
      Version: "2.0"
    }
  end
  
  private
  
  def encrypt(params)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = @key
    cipher.iv = @iv
    encrypted = cipher.update(params) + cipher.final
    encrypted.unpack('H*')[0] 
  end

  def generate_aes_sha256(key, iv, trade_info)
    encode_string = "HashKey=#{key}&#{trade_info}&HashIV=#{iv}"
    Digest::SHA256.hexdigest(encode_string).upcase
  end
end