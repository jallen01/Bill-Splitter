# Primary Author: Jonathan Allen (jallen01)

class GroupUser < ActiveRecord::Base

  # Attributes
  # ----------

  belongs_to :group
  belongs_to :user


  # Validations
  # -----------

  validates :cost, presence: true, currency: true

  # If no payment, set to 0.
  before_validation { payment.amount ||= 0 }
end
