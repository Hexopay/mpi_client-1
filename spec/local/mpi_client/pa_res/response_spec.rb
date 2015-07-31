require 'spec_helper'

describe "PaRes::Response" do
  before(:each) do
    @response = PaRes::Response.new('')
  end

  context 'xml contain sucessful response' do
    before(:each) do
      @response.stub!(:xml => <<-XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <Response type="pares">
            <Transaction id="33557">
                <ECI>05</ECI>
                <XID>xid5</XID>
                <CAVV>cavv3</CAVV>
                <CAVV_ALGORITHM>1</CAVV_ALGORITHM>
                <STATUS>Y</STATUS>
                <SIGNATURE>any signature</SIGNATURE>
            </Transaction>
        </Response>
        XML
      @response.parse
    end

    it "should be successful if xml does not contain Error item" do
      @response.should be_successful
    end

    it "should have eci" do
      @response.status.should == 'Y'
    end

    it "should have eci" do
      @response.eci.should == '05'
    end

    it "should have xid" do
      @response.xid.should == 'xid5'
    end

    it "should have cavv" do
      @response.cavv.should == 'cavv3'
    end

    it "should have cavv_algorithm" do
      @response.cavv_algorithm.should == '1'
    end

    it "should have signature" do
      @response.signature.should == 'any signature'
    end
  end

  context 'xml contains unexpected response' do
    before(:each) do
      @response.stub!(:xml => <<-XML)
          <xml>hello</xml>
        XML
      @response.parse
    end

    it "should not be successful if xml contains Error item" do
      @response.should_not be_successful
    end

    it "should contain error message and empty error code" do
      @response.error_message.should == 'Unknown response was received from MPI'
      @response.error_code.should == ''
    end
  end

  context "xml contains Error node" do
    before(:each) do
      @response.stub!(:xml => <<-XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <Response type="pares">
          <Error code="C5">Wrong data</Error>
        </Response>
        XML
      @response.parse
    end

    it "should not be successful" do
      @response.should_not be_successful
    end

    it "should contain error message" do
      @response.error_message.should match /Wrong data/
    end

    it "should contain error code" do
      @response.error_code.should == 'C5'
    end
  end
end
