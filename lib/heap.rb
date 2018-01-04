class BinaryMinHeap
  attr_reader :store, :prc

  def initialize(&prc)
    @store = []
    @prc = prc || Proc.new { |i, j| i <=> j }
  end

  def count
    @store.length
  end

  def extract
    min = @store[0]

    if count > 1
      @store[0] = @store.pop
      self.class.heapify_down(@store, 0, &prc)
    else
      @store.pop
    end

    min
  end

  def peek
    @store.first
  end

  def push(val)
    @store << val
    self.class.heapify_up(@store, self.count - 1, &prc)
  end

  public
  def self.child_indices(len, parent_index)
    [parent_index*2 + 1, parent_index*2 + 2].select { |i| i < len }
  end

  def self.parent_index(child_index)
    raise 'root has no parent' if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    prc ||= Proc.new { |i, j| i <=> j }

    first_child_idx, sec_child_idx = child_indices(len, parent_idx)

    parent_val = array[parent_idx]

    children = []
    children << array[first_child_idx] if first_child_idx
    children << array[sec_child_idx] if sec_child_idx

    if children.all? { |child| prc.call(parent_val, child) <= 0 }
      return array
    end

    new_par_idx = nil
    if children.length == 1
      new_par_idx = first_child_idx
    elsif prc.call(children[0], children[1]) == 1
      new_par_idx = sec_child_idx
    else
      new_par_idx = first_child_idx
    end

    array[parent_idx], array[new_par_idx] = array[new_par_idx], parent_val
    heapify_down(array, new_par_idx, len, &prc)
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    prc ||= Proc.new { |i, j| i <=> j }

    return array if child_idx == 0

    parent_idx = parent_index(child_idx)
    child_val, parent_val = array[child_idx], array[parent_idx]
    return array if prc.call(child_val, parent_val) >= 0

    array[child_idx], array[parent_idx] = parent_val, child_val
    heapify_up(array, parent_idx, len, &prc)
  end
end
