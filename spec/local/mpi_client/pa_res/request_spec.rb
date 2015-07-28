require 'spec_helper'

describe "PaRes::Request" do
  before(:each) do
    options = {
      account_id: '100',
      md:         '200',
      pa_res:     'any pa res'
    }

    @request = PaRes::Request.new(options)
  end

  describe "process" do
    it "should return MPIResponse" do
      @request.should_receive(:build_xml).ordered
      @request.should_receive(:post).ordered
      PaRes::Response.should_receive(:parse)
      @request.process
    end

    it "should invoke MPIResponse parse with xml response" do
      @request.stub!(build_xml: 'builded xml')
      @request.should_receive(:post).with('builded xml').and_return('xml response')
      PaRes::Response.should_receive(:parse).with("xml response")
      @request.process
    end
  end

  describe "post" do
    it "should post data with connection" do
      connection = mock(body: 'Response body')
      MPIClient.stub!(server_url: 'http://mpi-url/')
      @request.stub!(:connection).and_return(connection)
      connection.should_receive(:post).with('xml request').and_return(connection)
      @request.send(:post, 'xml request').should == 'Response body'
    end
  end

  describe "xml" do
    it "should contain request type" do
      xml = @request.send(:build_xml)
      xml.should match /REQUEST type="pares"/
    end

    it "should contain mapped options" do
      xml = @request.send(:build_xml)
      {'PARes' => 'any pa res', 'MD' => '200'}.each do |tag, value|
        xml.should match %r{<#{tag}>#{value}</#{tag}>}
      end
    end
  end
end
