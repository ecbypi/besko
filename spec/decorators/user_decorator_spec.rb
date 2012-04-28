require 'spec_helper'

describe UserDecorator do

  let(:user) { FactoryGirl.create(:mrhalp) }
  let(:decorator) { UserDecorator.new(user) }

  describe "#as_json" do

    let(:json) { decorator.as_json }

    it "contains the id, first_name, last_name, name, email, login and street columns" do
      json.should have_key 'id'
      json.should have_key 'first_name'
      json.should have_key 'last_name'
      json.should have_key 'name'
      json.should have_key 'email'
      json.should have_key 'login'
      json.should have_key 'email'
    end

    it "includes 'value' and 'label' keys if :as_autocomplete is true" do
      json = decorator.as_json as_autocomplete: true
      json.should have_key 'value'
      json.should have_key 'label'
      json['value'].should eq 'mrhalp'
      json['label'].should eq 'Micro Helpline'
    end
  end
end
