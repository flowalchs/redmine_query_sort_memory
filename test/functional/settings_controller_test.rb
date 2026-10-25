# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class QuerySortMemorySettingsControllerTest < Redmine::ControllerTest
  tests SettingsController

  fixtures :users, :email_addresses, :user_preferences

  def setup
    # The settings saved by another test can still be cached
    Setting.clear_cache
    @request.session[:user_id] = 1
  end

  # The settings saved here must not remain cached for the other tests
  def teardown
    Setting.clear_cache
  end

  def test_plugin_settings
    get(:plugin, :params => {:id => 'redmine_query_sort_memory'})
    assert_response :success
    assert_select 'select[name=?]', 'settings[storage]' do
      assert_select 'option', 3
      assert_select 'option[value=session][selected=selected]'
    end
    assert_select 'input[name=?][value="10"]', 'settings[max_queries]'
  end

  def test_update_plugin_settings
    post(:plugin, :params => {:id => 'redmine_query_sort_memory',
                              :settings => {'storage' => 'preference', 'max_queries' => '5'}})
    assert_redirected_to '/settings/plugin/redmine_query_sort_memory'
    assert_equal 'preference', RedmineQuerySortMemory::Store.storage
    assert_equal 5, RedmineQuerySortMemory::Store.max_queries
  end
end
