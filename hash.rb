raise IndexError if index.negative? || index >= @buckets.length


class HashMap
    def initialize
        @buckets = Array.new(16) {nil}
    end

    def hash(key)
        hash_code = 0
        prime_number = 31
           
        key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
           
        hash_code
    end

    def set(key,value)
        hash_code = hash(key)
        if @buckets[hash_code] == nil
            @buckets[hash_code] = LinkedList.new
            @buckets[hash_code].append([key,value])
        else
            current_node = @buckets[hash_code].head
            until current_node.nil?
                if current_node.value[0] == key
                    return current_node.value = [key,value]
                else
                    current_node = current_node.next_node
                end
            end
            @buckets[hash_code].append([key,value])
        end
    end

    def get(key)
        hash_code = hash(key)
        return nil if @buckets[hash_code].nil?
        current_node = @buckets[hash_code].head
        until current_node.nil?
            if current_node.value[0] == key
                return current_node.value[1]
            else
                current_node = current_node.next_node
            end
        end
        nil
    end

    def has(key)
        hash_code = hash(key)
        return false if @buckets[hash_code].nil?
        current_node = @buckets[hash_code].head
        until current_node.nil?
            if current_node.value[0] == key
                return true
            else
                current_node = current_node.next_node
            end
        end
        false
    end

    def remove(key)
        hash_code = hash(key)
        return nil if @buckets[hash_code].nil?
        current_node = @buckets[hash_code].head

        if current_node && current_node.value[0] == key
            value = current_node.value[1]
            @buckets[hash_code].head = current_node.next_node
            return value
        end

        until current_node.next_node.nil?
            if current_node.next_node.value[0] == key
                value = current_node.next_node.value[1]
                current_node.next_node = current_node.next_node.next_node
                return value
            else
                current_node = current_node.next_node
            end
        end
        nil
    end

    def length
        total_count = 0
        @buckets.each do |bucket|
            unless bucket.nil?
                current_node = bucket.head
                until current_node.nil?
                    total_count += 1
                    current_node = current_node.next_node
                end
            end
        end
        total_count
    end

    def clear
        @buckets.each_index do |index|
            @buckets[index] = nil
        end
    end

    def keys
        keys = []
        @buckets.each do |bucket|
            unless bucket.nil?
                current_node = bucket.head
                until current_node.nil?
                    keys << current_node.value[0]
                    current_node = current_node.next_node
                end
            end
        end
        keys
    end

    def values
        values = []
        @buckets.each do |bucket|
            unless bucket.nil?
                current_node = bucket.head
                until current_node.nil?
                    values << current_node.value[1]
                    current_node = current_node.next_node
                end
            end
        end
        values
    end

    def entries
        entries = []
        @buckets.each do |bucket|
            unless bucket.nil?
                current_node = bucket.head
                until current_node.nil?
                    entries << [current_node.value[0],current_node.value[1]]
                    current_node = current_node.next_node
                end
            end
        end
        entries
    end
end

class LinkedList

    attr_reader :head

    def initialize
        @head = nil
    end

    def append(value)
        if @head.nil?
            @head = Node.new(value) 
        else
            current_node = @head
            until current_node.next_node.nil?
                current_node = current_node.next_node
            end
            current_node.next_node = Node.new(value)
        end
    end

    def prepend(value)
        if @head.nil?
            @head = Node.new(value) 
        else
            new_node = Node.new(value)
            new_node.next_node = @head
            @head = new_node
        end
    end

    def size
        counter = 0
        current_node = @head
        until current_node.nil?
            counter += 1
            current_node = current_node.next_node
        end
        counter
    end

    def tail
        current_node = @head
        if current_node.nil?
            return current_node
        else
            until current_node.next_node.nil?
                current_node = current_node.next_node
            end
        end
        current_node
    end

    def at(index)
        counter = 0
        current_node = @head
        until current_node.nil?
            return current_node if counter == index
            current_node = current_node.next_node
            counter += 1
        end
        nil
    end

    def pop
        return nil if @head.nil?

        if @head.next_node.nil?
            popped_node = @head
            @head = nil
            return popped_node
        end

        current_node = @head
        until current_node.next_node.next_node.nil?
            current_node = current_node.next_node
        end
        popped_node = current_node.next_node
        current_node.next_node = nil  
        popped node
    end

    def contains?(value)
        return false if @head.nil?
        current_node = @head
        until current_node.nil?
            if current_node.value == value
                return true
            else
                current_node = current_node.next_node
            end
        end
        false
    end

    def find(value)
        return nil if @head.nil?
        current_node = @head
        index = 0
        until current_node.nil?
            return index if current_node.value == value
            current_node = current_node.next_node
            index += 1
        end
        nil
    end

    def to_s
        current_node = @head
        until current_node.nil?
            print "(#{current_node.value}) -> "
            current_node = current_node.next_node
        end
        print "nil"
    end

    def insert_at(value, index)
        new_node = Node.new(value)

        if index == 0
            new_node.next_node = @head
            @head = new_node
            return
        end

        current_node = @head
        counter = 0

        until current_node.nil?
            if counter + 1 == index
                new_node.next_node = current_node.next_node
                current_node.next_node = new_node
                return 
            else
                current_node = current_node.next_node
                counter += 1
            end
        end
        nil
    end

    def remove_at(index)
        return nil if @head.nil?
        if  index == 0
            @head = @head.next_node
            return
        end

        current_node = @head
        counter = 0

        until current_node.nil? || current_node.next_node.nil?
            if counter + 1 == index
                current_node.next_node = current_node.next_node.next_node
                return
            else
                current_node = current_node.next_node
                counter += 1
            end
        end
        nil
    end        
end

class Node
    attr_accessor :value, :next_node

    def initialize(value=nil, next_node=nil)
        @value = value
        @next_node = next_node
    end
end
