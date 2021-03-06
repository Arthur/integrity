require File.dirname(__FILE__) + "/../helpers"

class BrowsePublicProjectsTest < Test::Unit::TestCase
  include Helpers

  test "#pretty_date" do
    pretty_date(Time.now).should == "today"
    pretty_date(Time.mktime(Time.now.year, Time.now.month, Time.now.day-1)).should == "yesterday"

    pretty_date(Time.mktime(1995, 12, 01)).should == "on Dec 01st"
    pretty_date(Time.mktime(1995, 12, 21)).should == "on Dec 21st"
    pretty_date(Time.mktime(1995, 12, 31)).should == "on Dec 31st"

    pretty_date(Time.mktime(1995, 12, 22)).should == "on Dec 22nd"
    pretty_date(Time.mktime(1995, 12, 22)).should == "on Dec 22nd"

    pretty_date(Time.mktime(1995, 12, 03)).should == "on Dec 03rd"
    pretty_date(Time.mktime(1995, 12, 23)).should == "on Dec 23rd"

    pretty_date(Time.mktime(1995, 12, 15)).should == "on Dec 15th"
    pretty_date(Time.mktime(1995, 12, 15)).should == "on Dec 15th"
    pretty_date(Time.mktime(1995, 12, 15)).should == "on Dec 15th"
  end

  describe "paths with prefix" do
    before(:each) do
      stub(self).request { OpenStruct.new(:script_name => '/my_prefix') }
    end
    
    test "path_prefix" do
      path_prefix.should == "/my_prefix"
    end
    
    test "home_path" do
      home_path.should == "/my_prefix/"
    end
    
    test "login_path" do
      login_path.should == "/my_prefix/login"
    end
  end
  
  describe "#push_url_for" do
    before(:each) do
      setup_and_reset_database!
      @project = Project.gen(:integrity)
      Integrity.config[:admin_username] = "admin"
      Integrity.config[:admin_password] = "test"
      
      stub(self).request { OpenStruct.new(:scheme => "http", :port => "1234", :host => "integrity.example.org", :script_name => '') }
    end

    test "with auth disabled" do
      Integrity.config[:use_basic_auth] = false

      push_url_for(@project).should == "http://integrity.example.org:1234/integrity/push"
    end

    test "with auth and hashing enabled" do
      Integrity.config[:use_basic_auth]      = true
      Integrity.config[:hash_admin_password] = true

      push_url_for(@project).should == "http://admin:<password>@integrity.example.org:1234/integrity/push"
    end

    test "with auth enabled and hashing disabled" do
      Integrity.config[:use_basic_auth]      = true
      Integrity.config[:hash_admin_password] = false

      push_url_for(@project).should == "http://admin:test@integrity.example.org:1234/integrity/push"
    end
  end
end
