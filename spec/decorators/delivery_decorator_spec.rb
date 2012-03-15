require 'spec_helper'

describe DeliveryDecorator do

  let(:worker) { FactoryGirl.create(:user) }
  let(:delivery) { FactoryGirl.create(:delivery, deliverer: 'UPS', created_at: '2010-10-30 10:30:10', worker: worker) }
  let(:decorator) { DeliveryDecorator.new(delivery) }

  describe "#as_json" do
    let(:json) { decorator.as_json }
    it "forwards model.deliverer" do
      json.should have_key 'deliverer'
      json['deliverer'].should eq 'UPS'
    end

    it "includes worker attributes" do
      json.should have_key 'worker'
      json['worker'].should have_key 'id'
      json['worker'].should have_key 'first_name'
      json['worker'].should have_key 'last_name'
      json['worker'].should have_key 'login'
      json['worker'].should have_key 'email'
    end

    it "forwards package count" do
      json.should have_key 'package_count'
    end

    it "forwards formatted created_at" do
      json.should have_key 'delivered_at'
    end
  end
end
