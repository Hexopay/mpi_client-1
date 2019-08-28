require 'spec_helper'

describe 'test of verification request' do
  it "should have status 'N'" do
    req = Verification::Request.new(request_params(card_number: '4012001038443335'), '1')
    response = req.process
    response.status.should == 'N'
  end

  it "should return 'Y' and url" do
    req = Verification::Request.new(request_params, '2')
    response = req.process

    response.status.should == 'Y'
    response.url.should_not be_empty
    response.md.should_not be_empty
    response.pa_req.should_not be_empty
    response.acs_url.should_not be_empty
  end

  def request_params(new_params = {})
    {
      :account_id       => '246064ab504d39136c99bcb0b8d8b4f7',
      :amount           => '100',
      :card_number      => '4012001037141112',
      :description      => 'Test order',
      :display_amount   => '1 USD',
      :currency         => '840',
      :exp_month        => '12',
      :exp_year         => '16',
      :termination_url  => 'http://50acb15a.ngrok.io'
    }.update(new_params)
  end
end
