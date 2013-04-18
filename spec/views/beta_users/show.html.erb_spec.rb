require 'spec_helper'

describe "beta_users/show" do
  before(:each) do
    @beta_user = assign(:beta_user, stub_model(BetaUser,
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
  end
end
