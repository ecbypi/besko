module Arel
  def self.quote(string)
    Nodes.build_quoted(string)
  end
end
