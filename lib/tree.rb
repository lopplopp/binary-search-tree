class Tree
    def initialize(array)
        @input = array.sort.uniq
        @root = build_tree(@input)
    end

    def build_tree(array)
        return nil if array.empty?

        middle = array.length/2
        root_node = Node.new(array[middle])
        root_node.left = build_tree(array[0...middle])
        root_node.right = build_tree(array[(middle+1)..-1])
        root_node
    end

    def insert(value, node = @root)
        return if node.data == value

        if value > node.data
            node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
        else
            node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
        end
    end

    def delete(value, node = @root)
        return node if node.nil?
        node.right = delete(value, node.right) if node.data < value
        node.left = delete(value, node.left) if node.data > value

        if value == node.data
            return node.right if node.left.nil?
            return node.left if node.right.nil?

            if !(node.left.nil? && node.right.nil?)
                temp = node.right
                temp_data = temp.data
                until temp.nil?
                    temp_data = temp.data
                    temp = temp.left
                end
                node = delete(temp_data, node)
                node.data = temp_data
            end
        end
        node
    end

    def find(value, node = @root)
        return node if node.nil? || node.data == value
        if value > node.data
            find(value, node.right) 
        else
            find(value, node.left)
        end
    end

    def level_order(array = [], queue = [@root], &block)
        return array if queue.empty?

        to_do = queue.shift
        queue << to_do.left unless to_do.left.nil?
        queue << to_do.right unless to_do.right.nil?

        if block_given?
            array << yield(to_do.data)
        else
            array << to_do.data
        end
        queue[0] = level_order(array, queue, &block)
    end

    def inorder(array = [], node = @root, &block)
        return array if node.nil?
        inorder(array, node.left, &block)

        if block_given?
            array << yield(node.data)
        else
            array << node.data
        end

        inorder(array, node.right, &block)
    end

    def preorder(array = [], node = @root, &block)
        return array if node.nil?

        if block_given?
            array << yield(node.data)
        else
            array << node.data
        end

        preorder(array, node.left, &block)
        preorder(array, node.right, &block)
    end

    def postorder(array = [], node = @root, &block)
        return array if node.nil?

        postorder(array, node.left, &block)
        postorder(array, node.right, &block)

        if block_given?
            array << yield(node.data)
        else
            array << node.data
        end
    end

    def height(node = @root, height = -1)
        return height if node.nil?

        height += 1
        [height(node.left, height), height(node.right, height)].max
    end

    def depth(node,pointer = @root, depth = 0)
        return depth if node == pointer
        depth += 1
        if node.data < pointer.data
            depth(node, pointer.left, depth)
        else
            depth(node, pointer.right, depth)
        end
    end

    def balanced?
        return height(@root.right) == height(@root.left)
    end

    def rebalance
        @root = build_tree(inorder())
    end 

    def pretty_print(node = @root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
      end
end
