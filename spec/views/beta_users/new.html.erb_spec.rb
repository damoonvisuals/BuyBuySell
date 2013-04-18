require 'spec_helper'

describe "beta_users/new" do
  before(:each) do
    assign(:beta_user, stub_model(BetaUser,
      :email => "MyString"
    ).as_new_record)
  end

  it "renders new beta_user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => beta_users_path, :method => "post" do
      assert_select "input#beta_user_email", :name => "beta_user[email]"
    end
  end
end
