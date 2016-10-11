require "test_helper"
require "power_assert"
require "test/unit/power_assert"

class AntColonyOptimizerTest < Test::Unit::TestCase
  def test_initializer_default_values
    graph = [ [ 0.0, 1.0 ],
              [ 1.0, 0.0 ] ]
    instance = AntColonyOptimizer.new(graph)
    assert_equal(instance.instance_variable_get(:@node_num), 2)
    assert_equal(instance.instance_variable_get(:@alpha), 1.0)
    assert_equal(instance.instance_variable_get(:@beta), 0.5)
    assert_equal(instance.instance_variable_get(:@ro), 0.8)
    assert_equal(instance.instance_variable_get(:@ants), 2)
    assert_equal(instance.instance_variable_get(:@q), 1.0)
  end

  def test_initializer_with_keywordargs
    graph = [ [ 0.0, 1.0 ],
              [ 1.0, 0.0 ] ]
    instance = AntColonyOptimizer.new(graph,
                                      alpha: 2.0,
                                      beta: 3.0,
                                      ro: 1.0,
                                      ants: 10,
                                      q: 42.0)
    assert_equal(instance.instance_variable_get(:@node_num), 2)
    assert_equal(instance.instance_variable_get(:@alpha), 2.0)
    assert_equal(instance.instance_variable_get(:@beta), 3.0)
    assert_equal(instance.instance_variable_get(:@ro), 1.0)
    assert_equal(instance.instance_variable_get(:@ants), 10)
    assert_equal(instance.instance_variable_get(:@q), 42.0)
  end

  def test_greedy_path_cost
    matrix = [ [ 0.0, 1.0, 2.0 ],
               [ 1.0, 0.0, 2.5 ],
               [ 2.0, 2.5, 0.0 ] ]
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix, 0), 5.5)
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix, 1), 5.5)
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix, 2), 5.5)
    matrix2 = [ [ 0.0, 1.0, 2.0, 3.0 ],
                [ 1.0, 0.0, 2.0, 3.0 ],
                [ 2.0, 2.0, 0.0, 9.0 ],
                [ 3.0, 3.0, 9.0, 0.0 ] ]
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix2, 0), 15.0)
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix2, 1), 15.0)
    assert_equal(AntColonyOptimizer.greedy_path_cost(matrix2, 2), 15.0)
  end

  def test_initial_pheromone
    matrix = [ [ 0.0, 1.0, 2.0 ],
               [ 1.0, 0.0, 2.5 ],
               [ 2.0, 2.5, 0.0 ] ]
    instance = AntColonyOptimizer.new(matrix)
    assert_equal(instance.instance_variable_get(:@pheromone),
                 [ [     0.0, 3.0/5.5, 3.0/5.5 ],
                   [ 3.0/5.5,     0.0, 3.0/5.5 ],
                   [ 3.0/5.5, 3.0/5.5,     0.0 ] ])
    matrix2 = [ [ 0.0, 1.0, 2.0, 3.0 ],
                [ 1.0, 0.0, 2.0, 3.0 ],
                [ 2.0, 2.0, 0.0, 9.0 ],
                [ 3.0, 3.0, 9.0, 0.0 ] ]
    instance2 = AntColonyOptimizer.new(matrix2)
    assert_equal(instance2.instance_variable_get(:@pheromone),
                 [ [    0.0, 4.0/15, 4.0/15, 4.0/15 ],
                   [ 4.0/15,    0.0, 4.0/15, 4.0/15 ],
                   [ 4.0/15, 4.0/15,    0.0, 4.0/15 ],
                   [ 4.0/15, 4.0/15, 4.0/15,    0.0 ] ])
  end

  def test_optimize
    matrix = [ [ 0.0, 1.0, 2.0 ],
               [ 1.0, 0.0, 2.5 ],
               [ 2.0, 2.5, 0.0 ] ]
    colony = AntColonyOptimizer.new(matrix)
    path, cost = colony.optimize(10)
    assert_equal(cost, 5.5)
    power_assert do
      path == [0, 1, 2, 0] or path == [0, 2, 1, 0]
    end

    matrix2 = [ [ 0.0, 1.0, 2.0, 3.0 ],
                [ 1.0, 0.0, 2.0, 3.0 ],
                [ 2.0, 2.0, 0.0, 9.0 ],
                [ 3.0, 3.0, 9.0, 0.0 ] ]
    colony2 = AntColonyOptimizer.new(matrix2)
    path, cost = colony2.optimize(50)
    assert_equal(10, cost)
    power_assert do
      path == [0, 3, 1, 2, 0] or path == [0, 2, 1, 3, 0]
    end
  end
end

