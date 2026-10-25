# frozen_string_literal: true

module RedmineQuerySortMemory
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_sidebar_queries_bottom,
              :partial => 'hooks/query_sort_memory/sidebar'

    def controller_account_success_authentication_after(context={})
      return unless Store.storage == 'preference_session'

      Store.new(nil, context[:user]).clear
    end
  end
end
