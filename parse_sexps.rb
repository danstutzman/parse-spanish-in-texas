require 'pp'

ready_for_sexp = false
tree_stack = []
trees = []
File.open('input.txt.out').each_line do |line|
  line.strip!
  if line.start_with?('[Text')
    ready_for_sexp = true
  elsif ready_for_sexp
    if line == ''
      ready_for_sexp = false
    else
      line.scan(/\(|\)|[^() ]+/).each do |token|
        if token == '('
          tree_stack.push []
        elsif token == ')'
          if tree_stack.size > 1
            completed = tree_stack.pop
            tree_stack.last.push completed
          else
            trees.push tree_stack[0]
            tree_stack = []
          end
        else
          tree_stack.last.push token
        end
      end
    end
  end
end

def find_paths needle, haystack
  paths = []
  haystack.each_with_index do |part, i|
    if Array === part
      for child_part in find_paths(needle, part)
        paths.push [i] + child_part
      end
    elsif part == needle
      paths.push [i]
    end
  end
  paths
end

def extract_tree_by_path path, tree
  path, tree = path[1..-1], tree[path[0]]
  if path.size >= 1
    extract_tree_by_path path, tree
  else
    tree
  end
end

def extract_text tree
  if tree.size == 2 && String === tree[1]
    [tree[1]]
  else
    tree[1..-1].reduce([]) { |accum, part| accum + extract_text(part) }
  end
end

trees.each_with_index do |tree, tree_num|
  verb_paths = find_paths 'grup.verb', tree
  for verb_path in verb_paths
    raise if verb_path.last != 0
    verb_tree = extract_tree_by_path verb_path[0...-1], tree

    verb_text = extract_text(verb_tree)
    p verb_text

    previous_path = verb_path[0...-1]
    while previous_path.last == 1
      previous_path.pop
    end
    if previous_path != []
      p previous_path
      previous_path[-1] -= 1
      previous_tree = extract_tree_by_path previous_path, tree
      p [tree_num, previous_tree[0], extract_text(previous_tree), extract_text(verb_tree)]
    end

    next_path = verb_path[0...-1]
    while next_path != []
      next_path[-1] += 1
      next_tree = extract_tree_by_path next_path, tree
      if next_tree == nil
        next_path.pop
      else
        break
      end
    end
    if next_path != []
      p [tree_num, extract_text(verb_tree), next_tree[0], extract_text(next_tree)]
    end
  end
end
