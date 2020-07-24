class DirectorySearch
  API = PeopleApi.new

  def self.lookup(query)
    new(query).run
  end

  def initialize(query)
    @query = query
  end

  def run
    query_results = API.query(@query)

    query_results.each_with_object([]) do |data, all|
      record = Record.new(data)

      if record.contains_required_information?
        all << record
      end
    end
  end

  class Record
    include ActiveModel::SerializerSupport

    def initialize(data)
      @data = data
    end

    def contains_required_information?
      first_name.present? && last_name.present? && email.present?
    end

    def first_name
      @data["givenname"]
    end

    def last_name
      @data["surname"]
    end

    def email
      @data.fetch("email", []).first
    end

    def login
      @data["id"]
    end

    def street
      @data.fetch("office", []).first
    end

    def id
    end

    def active_model_serializer
      UserSerializer
    end
  end
end
