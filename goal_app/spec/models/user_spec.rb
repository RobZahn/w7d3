# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  subject(:user) { build(:user) }

    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:session_token) }
    it { should validate_presence_of(:password_digest) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_uniqueness_of(:session_token) }
    # it { is_expected.to callback(:ensure_session_token).after(:initialize) } #DID NOT WORK LEARN WHY

  describe "#is_password?" do
    let(:user) { create(:user) }
    it "should return true when given the correct password" do
      expect(user.is_password?('hunter2')).to be(true)
    end

    it "should return false when given the incorrect password" do
      expect(user.is_password?('hunter23')).to be(false)
    end
  end

  describe "::generate_session_token" do
    it "should generate a random session token" do
      expect(User.generate_session_token).to_not be(nil) #?????????
    end
  end

  describe "#password=" do
    let(:user) { create(:user) }
    it "should encrypt given password and store as user.password_digest" do
      expect(user.password_digest).to_not be(nil)
    end
  end

  describe "::find_by_credentials" do
    let(:user) { create(:user) }
    it "should return true when given the correct password" do
      expect(User.find_by_credentials(user.username, 'hunter2')).to eq(user)
    end

    it "should return nil when given the incorrect password" do
      expect(User.find_by_credentials(user.username, 'hunter22')).to eq(nil)
    end
  end

  describe "#reset_session_token!" do
    let!(:user) { create(:user) }
    let!(:token) { user.session_token }
    it "should generate a new session token" do
      expect(user.reset_session_token!).to_not eq(token)
    end
  end
end
