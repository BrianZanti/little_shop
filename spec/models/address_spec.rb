require 'rails_helper'

describe Address, typ: :model do
  describe "validations" do
    # it {should validate_presence_of(:user_id)}
    # it {should validate_presence_of(:street)}
    # it {should validate_presence_of(:city)}
    # it {should validate_presence_of(:state)}
    # it {should validate_presence_of(:zip_code)}
    # ^^ No validations because user must be able to delete all their addresses
  end



end
