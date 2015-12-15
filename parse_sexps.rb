require 'pp'

ready_for_sexp = false
tree_stack = []
trees = []
File.open('input.txt.out').each_line do |line|
#File.open('sample.txt').each_line do |line|
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
pp trees[2]
