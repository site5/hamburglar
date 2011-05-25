require 'spec_helper'

describe Hamburglar::Gateway do
  before :each do
    Hamburglar.gateway = :max_mind
    @gateway = Hamburglar::Gateway.new(:foo => :bar)
  end

  describe "::required_params" do
    it "returns @required_params without arguments" do
      Hamburglar::Gateway.required_params.should == []
    end

    it "sets @required_params with arguments" do
      Hamburglar::Gateway.required_params :one, :two, :three
      Hamburglar::Gateway.instance_variable_get(:@required_params).should ==
        [:one, :two, :three]
    end
  end

  describe "#initialize" do
    it "sets @params" do
      p = @gateway.instance_variable_get(:@params)
      p.should be_a Hash
      p.should have_key :foo
    end
  end

  describe "#params" do
    it "returns @params hash" do
      @gateway.params.should be_a Hash
      raw_params = @gateway.instance_variable_get(:@params)
      raw_params.should == @gateway.params
    end
  end

  describe "#validate!" do
    it "returns false if required_params aren't set" do
      Hamburglar::Gateway.required_params :one, :two
      @gateway.validate!.should == false
    end

    it "returns true if required_parames are set" do
      Hamburglar::Gateway.required_params :foo
      @gateway.validate!.should == true
    end
  end

  describe "#submit!" do
    it "raises InvalidGateway unless Hamburglar.gateway is set" do
      expect do
        Hamburglar.gateway = nil
        Hamburglar::Gateway.new.submit!
      end.to raise_error Hamburglar::InvalidGateway
    end

    it "returns false if required_params aren't set" do
      Hamburglar::Gateway.new.submit!.should == false
    end
  end
end
