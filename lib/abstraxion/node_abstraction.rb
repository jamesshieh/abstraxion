module NodeAbxn
  class Grid < TowerAbxn::Grid
    def generate_grid
      grid = []
      @y.times do 
        row = []
        @x.times do
          row << Atom.new(id.resume)
        end
        grid << row
      end
      set_neighbors
      grid
    end
  end
  class Atom
    def initialize(id)
      @id = id
      @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
      @out_conn = nil
      @pulses = []
    end
    
  end


  class Amplifier < Atom
  end
  class Prism < Atom
  end
  class Polarizer < Atom
  end
  class Reflector < Atom
  end
  class Refractor < Atom
  end
end

