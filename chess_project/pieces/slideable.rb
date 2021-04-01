module Slidable
    HORIZONTAL_VERTICAL_DIRS=[[-1,0],[1,0],[0,-1],[0,1]].freeze
    DIAGONAL_DIRS=[[1,1],[1,-1],[-1,1],[-1,-1]].freeze

    def horizontal_vertical_dirs 
        HORIZONTAL_VERTICAL_DIRS
    end

    def diagonal_dirs 
        DIAGONAL_DIRS
    end

    def moves
        moves=[]        
        move_dirs.each do |dx,dy|
            moves+=grow_unblocked_moves_in_dir(dx,dy)
        end
        moves
    end

    def move_dirs
        #subclass overrides this method
        raise NotImplementedError
    end

    def grow_unblocked_moves_in_dir(dx,dy)
        cur_x,cur_y=pos
        moveables=[]
        loop do 
            cur_x,cur_y=cur_x+dx,cur_y+dy
            pos=[cur_x,cur_y]

            break unless board.valid_pos?(pos)

            if board.empty?(pos)
                moveables<<pos
            else
                moveables<<pos if board[pos].color!=color
                break
            end
        end
        moveables
    end
        
end