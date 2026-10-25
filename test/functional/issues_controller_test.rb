# frozen_string_literal: true

require File.expand_path('../test_helper', __dir__)

class QuerySortMemoryIssuesControllerTest < Redmine::ControllerTest
  include RedmineQuerySortMemory::TestHelper
  tests IssuesController

  fixtures :projects, :users, :email_addresses, :user_preferences, :members, :member_roles, :roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_projects,
           :custom_fields_trackers, :versions, :workflows, :queries

  def setup
    @request.session[:user_id] = 2
    @query1 = create_query('query1', [['id', 'asc']])
    @query2 = create_query('query2', [['id', 'asc']])
  end

  def test_each_query_should_keep_its_own_sort_order
    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'session', 'max_queries' => '10'} do
      get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
      assert_sorted_by_id_desc

      get(:index, :params => {:query_id => @query2.id})
      assert_sorted_by_id_asc

      get(:index, :params => {:query_id => @query1.id})
      assert_sorted_by_id_desc
    end
  end

  def test_going_back_to_the_issue_list_should_keep_the_sort_order
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})

    get :index
    assert_sorted_by_id_desc
  end

  def test_previous_and_next_links_should_follow_the_remembered_sort_order
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
    ids = issue_ids_in_list

    get(:show, :params => {:id => ids[1]})
    assert_select 'div.next-prev-links' do
      assert_select 'a[href=?]', "/issues/#{ids[0]}", :text => /Previous/
      assert_select 'a[href=?]', "/issues/#{ids[2]}", :text => /Next/
    end
  end

  def test_sorting_by_the_sort_order_of_the_query_should_forget_the_sort_order
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
    get(:index, :params => {:query_id => @query1.id, :sort => 'id'})
    assert_equal({}, session[:query_sort_memory])

    get(:index, :params => {:query_id => @query1.id})
    assert_sorted_by_id_asc
  end

  def test_sidebar_should_show_reset_link_for_a_remembered_sort_order
    get(:index, :params => {:query_id => @query1.id})
    assert_select 'p.query-sort-memory', 0

    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
    assert_select 'p.query-sort-memory a[href=?]', "/issues?query_id=#{@query1.id}&query_sort_memory_reset=1"
  end

  def test_reset_should_forget_the_sort_order
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})

    get(:index, :params => {:query_id => @query1.id, :query_sort_memory_reset => 1})
    assert_sorted_by_id_asc
    assert_select 'p.query-sort-memory', 0

    get :index
    assert_sorted_by_id_asc
  end

  def test_should_only_keep_the_most_recently_sorted_queries
    query3 = create_query('query3', [['id', 'asc']])
    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'session', 'max_queries' => '2'} do
      [@query1, @query2, query3].each do |query|
        get(:index, :params => {:query_id => query.id, :sort => 'id:desc'})
      end
      assert_equal [@query2.id.to_s, query3.id.to_s], session[:query_sort_memory].keys

      get(:index, :params => {:query_id => @query1.id})
      assert_sorted_by_id_asc
    end
  end

  def test_preference_storage_should_keep_the_sort_order_in_a_new_session
    with_settings :plugin_redmine_query_sort_memory => {'storage' => 'preference', 'max_queries' => '10'} do
      get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
      assert_equal({@query1.id.to_s => 'id:desc'}, User.find(2).pref[:query_sort_memory])

      session.clear
      @request.session[:user_id] = 2
      get(:index, :params => {:query_id => @query1.id})
      assert_sorted_by_id_desc
    end
  end

  def test_session_storage_should_not_change_the_user_preference
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})
    assert_nil User.find(2).pref[:query_sort_memory]
  end

  def test_api_request_should_not_use_the_remembered_sort_order
    get(:index, :params => {:query_id => @query1.id, :sort => 'id:desc'})

    with_settings :rest_api_enabled => '1' do
      get(:index, :params => {:query_id => @query1.id, :format => 'json', :key => User.find(2).api_key})
    end
    ids = ActiveSupport::JSON.decode(response.body)['issues'].pluck('id')
    assert ids.size > 1
    assert_equal ids.sort, ids
  end
end
