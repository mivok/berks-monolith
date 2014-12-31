require_relative 'monolith/commands'

require_relative 'monolith/locations/git'
require_relative 'monolith/locations/github'
require_relative 'monolith/locations/path'
require_relative 'monolith/locations/default'

module Monolith
  def self.formatter
    @formatter ||= Monolith::Formatter.new
  end
end
