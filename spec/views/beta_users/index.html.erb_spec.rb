require 'spec_helper'

describe "beta_users/index" do
  before(:each) do
    assign(:beta_users, [
      stub_model(BetaUser,
        :email => "Email"
      ),
      stub_model(BetaUser,
        :email => "Email"
      )
    ])
  end

  it "renders a list of beta_users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
