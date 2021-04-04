require_relative 'display'

class HumanPlayer < Player

    def make_move
        result=nil
        until result
            @display.render
            result=@display.cursor.get_input
        end
        result
    end
end