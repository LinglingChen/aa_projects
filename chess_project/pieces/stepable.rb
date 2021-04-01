module Stepable

    def moves
        move_diffs.each_with_object([]) do |(dx,dy),moves|
            cur_x,cur_y=pos
            pos=[cur_x+dx,cur_y+dy]

            next unless board.valid_pos?(pos)

            if board.empty?(pos)
                moves<<pos
            else
                moves<<pos if board[pos].color!=color
            end
        end        
    end

    def move_diffs
        #subclass overrides this method
        raise NotImplementedError
    end

end