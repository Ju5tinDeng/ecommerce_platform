class NewebpayResponse
  attr_reader :response

  def initialize(params)
    @key = ENV["HASH_KEY"]
    @iv = ENV["HASH_IV"]

    @response = decrypt(params)
  end

  private

  def decrypt(encrypted_string)
    encrypted_data = [encrypted_string].pack('H*')
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.padding = 0
    decipher.key = @key
    decipher.iv = @iv
    data = decipher.update(encrypted_data) + decipher.final
    raw_data = strippadding(data)
    JSON.parse(raw_data)
  end

  def strippadding(string)
    last_char = string[-1].ord
    padding_char = last_char.chr
    padding_check = string[-last_char..-1]
  
    if padding_check == padding_char * last_char
      return string[0..-(last_char + 1)]
    else
      return false
    end
  end
end