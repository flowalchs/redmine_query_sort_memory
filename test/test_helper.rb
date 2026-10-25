# frozen_string_literal: true

if ENV['COVERAGE']
  require 'simplecov'

  # The Cobertura report for Codecov needs simplecov-cobertura, which is
  # installed in CI (see .github/workflows/build.yml)
  coverage_formatters = [SimpleCov::Formatter::HTMLFormatter]
  begin
    require 'simplecov-cobertura'
    coverage_formatters << SimpleCov::Formatter::CoberturaFormatter
  rescue LoadError
    warn 'simplecov-cobertura is not installed, only the HTML coverage report is created'
  end

  SimpleCov.coverage_dir 'coverage'

  SimpleCov.start :rails do
    add_filter 'init.rb'
    root File.expand_path("#{File.dirname __FILE__}/..")
  end
end

$VERBOSE = nil if ENV['SUPPRESS_WARNINGS']

# Load the normal Rails helper
require File.expand_path('../../../test/test_helper', __dir__)

# The test helper of Redmine 6.1 and 7.0 sets its own formatter, so the
# formatters are set after loading it
SimpleCov.formatters = coverage_formatters if ENV['COVERAGE']

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
