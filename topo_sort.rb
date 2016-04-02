class TopoSort

  class CyclicDependenciesError < StandardError
  end

  attr_accessor :stack, :graph, :node_state
  def initialize(dependency_hash:)
    @graph = dependency_hash
    @stack = []
    @node_state = {}
  end

  def try_sort(node)
    raise CyclicDependenciesError.new if node_state[node] == :visiting
    return if node_state[node] == :visited
    node_state[node] = :visiting
    graph[node].map {|dependency| try_sort(dependency)}
    stack.push(node)
    node_state[node] = :visited
  end

  def sort
    graph.keys.map {|node| try_sort(node)}
    return stack
  end
end

dag = {5 => [2,0], 4 => [0,1], 2 => [3], 3 => [1], 1 => [], 0 => []}
sorted_dag = dag.sort_by{|k,_| k}.to_h

cyclic = {1=>[2], 2=>[3, 4], 3=>[2], 4=>[]}

puts TopoSort.new(dependency_hash: dag).sort.inspect
#=> [1, 3, 2, 0, 5, 4]

puts TopoSort.new(dependency_hash: sorted_dag).sort.inspect
#=> [0, 1, 3, 2, 4, 5]

puts TopoSort.new(dependency_hash: cyclic).sort.inspect
# => topo_sort.rb:14:in `try_sort': TopoSort::CyclicDependenciesError (TopoSort::CyclicDependenciesError)
