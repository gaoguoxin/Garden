module Encryption
  def self.encrypt_password(string)
    key = EzCrypto::Key.with_password("password", "garden&oopsdata")
    return Base64.encode64(key.encrypt(string.to_s))
  end

  def self.decrypt_password(string)
    key = EzCrypto::Key.with_password("password", "garden&oopsdata")
    return key.decrypt(Base64.decode64(string.to_s))
  end
end
