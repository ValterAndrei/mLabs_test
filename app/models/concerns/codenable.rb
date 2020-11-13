module Codenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_code
  end

  protected

  def generate_code
    self.code = loop do
      random_code = SecureRandom.hex(3).upcase

      break random_code unless self.class.exists?(code: random_code)
    end
  end
end
