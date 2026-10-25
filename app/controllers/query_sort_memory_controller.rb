# frozen_string_literal: true

class QuerySortMemoryController < ApplicationController
  before_action :require_login

  # Forgets the remembered sort orders of all queries of the current user
  def reset
    RedmineQuerySortMemory::Store.new(session, User.current).clear
    flash[:notice] = l(:notice_query_sort_memory_reset_all)
    redirect_back_or_default issues_path
  end
end
