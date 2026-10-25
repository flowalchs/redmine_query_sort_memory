# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'
  require 'simplecov-cobertura'

  SimpleCov.coverage_dir 'coverage'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::CoberturaFormatter
  ]

  SimpleCov.start :rails do
    add_filter 'init.rb'
    root File.expand_path("#{File.dirname __FILE__}/..")
  end

  # Cobertura-XML at the end
  at_exit do
    result = SimpleCov.result
    # Cobertura-file
    SimpleCov::Formatter::CoberturaFormatter.new.format(result)
    # html also
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
  end
end

$VERBOSE = nil if ENV['SUPPRESS_WARNINGS']

# Load the normal Rails helper
require File.expand_path('../../../test/test_helper', __dir__)

module RedmineQuerySortMemory
  module TestHelper
    def create_query(name, sort_criteria)
      IssueQuery.create!(:name => name, :visibility => IssueQuery::VISIBILITY_PUBLIC,
                         :user_id => 1, :sort_criteria => sort_criteria)
    end

    def issue_ids_in_list
      css_select('tr.issue td.id').map {|e| e.text.to_i}
    end

    def assert_sorted_by_id_desc
      ids = issue_ids_in_list
      assert ids.size > 1
      assert_equal ids.sort.reverse, ids
    end

    def assert_sorted_by_id_asc
      ids = issue_ids_in_list
      assert ids.size > 1
      assert_equal ids.sort, ids
    end
  end
end
