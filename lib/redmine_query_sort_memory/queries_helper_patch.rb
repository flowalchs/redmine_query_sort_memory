# frozen_string_literal: true

module RedmineQuerySortMemory
  module QueriesHelperPatch
    RESET_PARAM = :query_sort_memory_reset

    def retrieve_query(klass=IssueQuery, use_session=true, options={})
      query = super
      if use_session && !api_request? && query&.persisted?
        apply_query_sort_memory(query, klass.name.underscore.to_sym)
      end
      query
    end

    # Used for the previous/next links on the issue page
    def retrieve_query_from_session(klass=IssueQuery)
      query = super
      if query&.persisted? && (sort_criteria = query_sort_memory.recall(query))
        query.sort_criteria = sort_criteria
      end
      query
    end

    def query_sort_memory
      @query_sort_memory ||= RedmineQuerySortMemory::Store.new(session, User.current)
    end

    private

    def apply_query_sort_memory(query, session_key)
      if params[RESET_PARAM].present?
        query_sort_memory.forget(query)
        query.sort_criteria = query.attribute_in_database(:sort_criteria)
      elsif params[:sort].present?
        if query.sort_criteria == saved_sort_criteria(query)
          query_sort_memory.forget(query)
        else
          query_sort_memory.remember(query)
        end
      elsif (sort_criteria = query_sort_memory.recall(query))
        query.sort_criteria = sort_criteria
      end
      session[session_key][:sort] = query.sort_criteria.to_a if session[session_key].is_a?(Hash)
    end

    def saved_sort_criteria(query)
      Redmine::SortCriteria.new(query.attribute_in_database(:sort_criteria).presence || query.default_sort_criteria)
    end
  end
end
