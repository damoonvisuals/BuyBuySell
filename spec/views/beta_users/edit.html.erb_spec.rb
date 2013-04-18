require 'spec_helper'

describe "beta_users/edit" do
  before(:each) do
    @beta_user = assign(:beta_user, stub_model(BetaUser,
      :email => "MyString"
    ))
  end

  it "renders the edit beta_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beta_users_path(@beta_user), :method => "post" do
      assert_select "input#beta_user_email", :name => "beta_user[email]"
    end
  end
end
