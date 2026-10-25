# frozen_string_literal: true

module RedmineQuerySortMemory
  VERSION = '0.1.0'

  DEFAULT_SETTINGS = {
    'storage' => 'session',
    'max_queries' => '10'
  }.freeze
end
