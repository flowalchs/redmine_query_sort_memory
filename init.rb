# frozen_string_literal: true

Redmine::Plugin.register :redmine_query_sort_memory do
  name 'Redmine Query Sort Memory'
  author 'Florian Walchshofer'
  author_url 'https://github.com/flowalchs/'
  description 'Remembers the sort order selected in a saved query for each user'
  url 'https://github.com/flowalchs/redmine_query_sort_memory/'
  version RedmineQuerySortMemory::VERSION
  requires_redmine :version_or_higher => '6.0.0'

  settings :default => RedmineQuerySortMemory::DEFAULT_SETTINGS,
           :partial => 'settings/query_sort_memory'
end

unless QueriesHelper.include?(RedmineQuerySortMemory::QueriesHelperPatch)
  QueriesHelper.prepend(RedmineQuerySortMemory::QueriesHelperPatch)
end

# Registers the hook listener
RedmineQuerySortMemory::Hooks
