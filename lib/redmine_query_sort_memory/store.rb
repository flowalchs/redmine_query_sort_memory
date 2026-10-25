# frozen_string_literal: true

module RedmineQuerySortMemory
  # Remembers the sort order selected for each saved query, either in the
  # session or in the preferences of the user.
  #
  # The sort orders are stored as a hash of query ids and sort parameters
  # (e.g. {"12" => "updated_on:desc,priority"}). Only the most recently
  # sorted queries are kept.
  class Store
    KEY = :query_sort_memory
    STORAGES = %w[session preference_session preference].freeze

    def self.settings
      Setting.plugin_redmine_query_sort_memory || {}
    end

    # Returns "session", "preference_session" (user preference, cleared at
    # login) or "preference" (user preference, kept)
    def self.storage
      storage = settings['storage'].to_s
      STORAGES.include?(storage) ? storage : DEFAULT_SETTINGS['storage']
    end

    def self.max_queries
      max = settings['max_queries'].to_i
      max > 0 ? max : DEFAULT_SETTINGS['max_queries'].to_i
    end

    def initialize(session, user)
      @session = session
      @user = user
    end

    # Returns the remembered sort criteria of the query, or nil
    def recall(query)
      param = entries[query.id.to_s]
      Redmine::SortCriteria.new(param) if param.present?
    end

    # Remembers the current sort criteria of the query
    def remember(query)
      list = entries
      key = query.id.to_s
      list.delete(key)
      list[key] = query.sort_criteria.to_param
      list.shift while list.size > self.class.max_queries
      save(list)
    end

    def forget(query)
      list = entries
      save(list) if list.delete(query.id.to_s)
    end

    def clear
      save({})
    end

    private

    def use_preference?
      self.class.storage != 'session' && @user&.logged?
    end

    def entries
      list = use_preference? ? @user.pref[KEY] : @session&.[](KEY)
      list.is_a?(Hash) ? list.to_h.transform_keys(&:to_s) : {}
    end

    def save(list)
      if use_preference?
        @user.pref[KEY] = list
        @user.pref.save
      elsif @session
        @session[KEY] = list
      end
    end
  end
end
