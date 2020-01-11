require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_uniqueness_of :email }
    it { should define_enum_for(:role).with_values([:user, :merchant_employee, :merchant_admin, :admin_user]) }
  end
  describe "relationships" do
    it { should have_many :orders }
    it { should belong_to(:merchant).optional }
  end
  describe "roles" do
    it "can be created as a user" do
      user = User.create(name: "penelope",
                         password: "boom",
                         role: 0)
      expect(user.role).to eq("user")
      expect(user.user?).to be_truthy
    end

    it "can be created as a merchant_employee" do
      user = User.create(name: "sammy",
                         password: "pass",
                         role: 1)
      expect(user.role).to eq("merchant_employee")
      expect(user.merchant_employee?).to be_truthy
    end

    it "can be created as a merchant_admin" do
      user = User.create(name: "sammy",
                         password: "pass",
                         role: 2)
      expect(user.role).to eq("merchant_admin")
      expect(user.merchant_admin?).to be_truthy
    end

    it "can be created as an admin_user" do
      user = User.create(name: "sammy",
                         password: "pass",
                         role: 3)
      expect(user.role).to eq("admin_user")
      expect(user.admin_user?).to be_truthy
    end
  end
end
