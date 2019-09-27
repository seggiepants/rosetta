=begin
Class to model the position of a "Mugwump" on a grid
as well as if it has been found or not.
=end
class Position

    attr_accessor :x
    attr_accessor :y
    attr_accessor :found

    # constructor
    def initialize()
        @x = 0
        @y = 0
        @found = false
    end

=begin
    Place the mugwump at a random location on the grid.
    Parameters:
    * max_x - number of horizontal spaces on the grid goes from 0 to one less than the given value.
    * max_y - number of vertical spaces on the grid goes from 0 to one less than the given value.
=end
    def random_position(max_x, max_y)
        @x = rand(max_x)
        @y = rand(max_y)
        @found = false
    end
end