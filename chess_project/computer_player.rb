require_relative 'player'

class ComputerPlayer < Player

    def make_move(_board)
        start_pos, end_pos = nil, nil
        until start_pos && end_pos
            display.render

            piece_to_move=_board.pieces.select {|p| p.color==:black && !p.valid_moves.empty?}.sample
            start_pos=piece_to_move.pos            

            attack_moves=piece_to_move.valid_moves.select {|pos| _board[pos].color==:white}
            end_pos=attack_moves.sample unless attack_moves.empty?
            end_pos=piece_to_move.valid_moves.sample if attack_moves.empty?
            
        end

        [start_pos, end_pos]
    end

end