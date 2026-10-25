# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class QuerySortMemoryAccountControllerTest < Redmine::ControllerTest
  tests AccountController

  fixtures :users, :email_addresses, :user_preferences, :roles

  def setup
    user = User.find(2)
    user.pref[:query_sort_memory] = {'1' => 'id:desc'}
    user.pref.save!
  end

  def test_login_should_clear_the_sort_orders_with_preference_session_storage
    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'preference_session', 'max_queries' => '10'} do
      post(:login, :params => {:username => 'jsmith', :password => 'jsmith'})
      assert_redirected_to '/my/page'
      assert_equal({}, User.find(2).pref[:query_sort_memory])
    end
  end

  def test_login_should_keep_the_sort_orders_with_preference_storage
    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'preference', 'max_queries' => '10'} do
      post(:login, :params => {:username => 'jsmith', :password => 'jsmith'})
      assert_equal({'1' => 'id:desc'}, User.find(2).pref[:query_sort_memory])
    end
  end
end
