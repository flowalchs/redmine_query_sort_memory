# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class QuerySortMemoryControllerTest < Redmine::ControllerTest
  fixtures :users, :email_addresses, :user_preferences

  def test_reset_should_forget_all_sort_orders_in_the_session
    @request.session[:user_id] = 2
    @request.session[:query_sort_memory] = {'1' => 'id:desc', '2' => 'subject'}

    post(:reset, :params => {:back_url => '/projects/ecookbook/issues'})
    assert_redirected_to '/projects/ecookbook/issues'
    assert_equal 'All remembered sort orders have been reset.', flash[:notice]
    assert_equal({}, session[:query_sort_memory])
  end

  def test_reset_should_forget_all_sort_orders_in_the_user_preference
    user = User.find(2)
    user.pref[:query_sort_memory] = {'1' => 'id:desc', '2' => 'subject'}
    user.pref.save!
    @request.session[:user_id] = 2

    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'preference', 'max_queries' => '10'} do
      post :reset
    end
    assert_redirected_to '/issues'
    assert_equal({}, User.find(2).pref[:query_sort_memory])
  end

  def test_reset_should_require_login
    post :reset
    assert_response :redirect
    assert_match %r{/login}, response.location
  end

  def test_reset_route
    assert_routing({:method => 'post', :path => '/query_sort_memory/reset'},
                   {:controller => 'query_sort_memory', :action => 'reset'})
  end
end
