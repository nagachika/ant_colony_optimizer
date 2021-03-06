# coding: utf-8
# frozen-string-literal: true

class AntColonyOptimizer
  def initialize(graph_matrix, alpha: 1.0, beta: 0.5, ro: 0.8, ants: graph_matrix[0].size, q: 1.0)
    @matrix = graph_matrix
    @node_num = @matrix.size
    @alpha = alpha
    @beta = beta
    @ro = ro
    @q = q
    @ants = ants
    initialize_pheromone
    @min_cost = Float::MAX
    @best_path = nil
  end

  def self.greedy_path_cost(matrix, start)
    node_num = matrix.size
    visited = [start]
    i = start
    cost = 0.0
    while visited.size < node_num
      min_cost = Float::MAX
      next_cand = nil
      matrix[i].each_with_index do |c, j|
        if not(visited.include?(j)) and min_cost > c
          min_cost = c
          next_cand = j
        end
      end
      i = next_cand
      cost += min_cost
      visited << i
    end
    cost += matrix[i][start]
    cost
  end

  def initialize_pheromone
    total_greedy_path_cost = 0
    @node_num.times do |i|
      total_greedy_path_cost += self.class.greedy_path_cost(@matrix, i)
    end
    avg = total_greedy_path_cost.to_f / @node_num
    initial_phero = @ants / avg
    @pheromone = @node_num.times.map{|i|
      @node_num.times.map{|j|
        if i == j or @matrix[i][j] == 0
          0
        else
          initial_phero
        end
      }
    }
  end

  def find_path
    # start from index 0
    costs = []
    cost = 0.0
    i = 0
    visited = [0]
    remain = (1..(@node_num-1)).to_a
    until remain.empty?
      sum = 0.0
      probs = remain.map{|j|
        if @matrix[i][j] == 0
          p = 0.0
        else
          p = (@pheromone[i][j] ** @alpha) * (@matrix[i][j] ** -@beta)
        end
        sum += p
        sum
      }
      if sum == 0.0
        idx = 0
      else
        probs.map!{|p| p / sum }
        idx = probs.index{|p| p > rand }
        raise "idx is nil #{probs.inspect}" if idx.nil?
      end
      next_i = remain[idx]
      remain.delete(next_i)
      visited << next_i
      cost += @matrix[i][next_i]
      if @matrix[0][next_i] == 0
        costs << cost
        cost = 0.0
      end
      i = next_i
    end
    visited << 0
    cost += @matrix[i][0]
    costs << cost
    [visited, costs.max]
  end

  def update_pheromone(paths)
    @node_num.times do |i|
      @node_num.times do |j|
        next if i == j
        next if @matrix[i][j] == 0.0
        curr = @pheromone[i][j]
        new = curr * @ro + paths.inject(0.0){|sum, (path, cost)|
          if path.each_cons(2).find{|cons| cons == [i,j] or cons == [j,i] }
            sum + @q.to_f / cost
          else
            sum
          end
        }
        @pheromone[i][j] = @pheromone[j][i] = new
      end
    end
  end

  def step
    min_cost = Float::MAX
    best_path = nil
    paths = []
    # trace path by every ant
    @ants.times do
      path, cost = find_path
      if cost < min_cost
        min_cost = cost
        best_path = path
      end
      paths << [path, cost]
    end
    # update pheromone
    update_pheromone(paths)

    [best_path, min_cost]
  end

  def optimize(iteration, best_path_callback: nil)
    iteration.times do |i|
      path, cost = step
      if block_given?
        yield [i, path, cost]
      end
      if cost < @min_cost
        @min_cost = cost
        @best_path = path
        if best_path_callback.respond_to?(:call)
          best_path_callback.call(i, path, cost)
        end
      end
    end
    [@best_path, @min_cost]
  end
end
