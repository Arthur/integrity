require File.dirname(__FILE__) + "/../helpers"

class IntegrityTest < Test::Unit::TestCase
  it "loads config file" do
    file = File.dirname(__FILE__) + "/../../config/config.sample.yml"
    Integrity.load_config(file)

    Integrity.config[:base_uri].should == "http://integrity.domain.tld"
    Integrity.config[:export_directory].should == "/home/integrity/exports"
  end

  it "is possible to set config as an hash" do
    Integrity.config[:foo] = "bar"
    Integrity.config[:foo].should == "bar"
  end

  it "works just fine and use default configuration if nothing specified" do
    Integrity.config[:foo] = "bar"
  end
end
