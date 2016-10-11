require "test_helper"

class VersionTest < Test::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::AntColonyOptimizer::VERSION
  end
end
