class User < ActiveRecord::Base
  class SearchQuery
    attr_reader :query

    def initialize(query)
      @query = query
    end

    def result
      User.where(
        matches_full_name.or(
          matches_last_name
        ).or(
          matches_any_for_column(:first_name)
        ).or(
          matches_any_for_column(:email)
        ).or(
          matches_any_for_column(:login)
        )
      )
    end

    private

    def sanitized_query
      @sanitized_query = query.gsub('\\', '\\' * 3).gsub('%', '\\%').gsub('_', '\\_')
    end

    def terms
      @terms ||= sanitized_query.split.map do |term|
        Arel.quote("#{term}%")
      end
    end

    def matches_full_name
      full_name.matches(Arel.quote("#{sanitized_query}%"))
    end

    def matches_last_name
      table[:last_name].matches(terms.last)
    end

    def matches_any_for_column(column)
      terms.map do |term|
        table[column].matches(term)
      end.reduce(:or)
    end

    def full_name
      Arel::Nodes::NamedFunction.new('concat', [table[:first_name], Arel.quote(' '), table[:last_name]])
    end

    def table
      User.arel_table
    end
  end
end
