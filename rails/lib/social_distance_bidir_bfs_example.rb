# Breadth-First-Search) to see how many people are between two persons.
# Now comes with bi-directional flavor, where two BFS'es are searched simultaneously
# from both ends. This ensures better performance with large datasets
def social_distance_to user_id

  fake_test_data = {
      1 => [5,6],
      5 => [1],
      6 => [1,7,8],
      7 => [6],
      8 => [6, 9, 12],
      9 => [8],
      12 => [13, 8],
      13 => [12,14],
      14 => [13]
  }

  start_id = 1
  end_id = user_id

  get_vertices = lambda { |x|
    fake_test_data[x] || []
  }

  a = start_id
  b = end_id
  marked = Set.new # keep track of checked vertices
  depth_a = get_vertices.call a
  depth_b = get_vertices.call b
  # check for distance=1 here, next checks will be for a common vertex in-between
  return 1 if b.in? depth_a
  distance = 2
  next_depth_a = []
  next_depth_b = []
  while depth_a.size > 0 && depth_b.size > 0
    # first check for even distances
    return distance if (depth_a & depth_b).size > 0
    distance += 1
    # get full front on next depth (all connected vertices of all vertices on this depth)
    depth_a.each do |aa|
      unless aa.in? marked
        next_depth_a += get_vertices.call aa
        marked.add(aa)
      end
    end
    # ... same for the other end
    depth_b.each do |bb|
      unless bb.in? marked
        next_depth_b += get_vertices.call bb
        marked.add(bb)
      end
    end
    depth_a = next_depth_a
    # second check with only one front moved forward (otherwise we might "jump over" the common vertex)
    return distance if (depth_a & depth_b).size > 0
    distance += 1
    depth_b = next_depth_b
    next_depth_a = next_depth_b = []
  end
end

