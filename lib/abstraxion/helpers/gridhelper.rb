module GridHelper
  # Enumerator object to iterate over nodes
  def grid_iterator
    Enumerator.new do |x|
      @grid.each do |row|
        row.each do |col|
          x << col
        end
      end
    end
  end

end


