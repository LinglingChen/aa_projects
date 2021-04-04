require_relative 'pieces'

class Board

    attr_reader :rows

    def initialize(fill_board=true)
        @sentinel=NullPiece.instance
        make_starting_grid(fill_board)        
    end

    def [](pos)
        raise 'invalid pos' unless valid_pos?(pos)
        x,y=pos
        @rows[x][y]
    end

    def []=(pos,piece)
        raise 'invalid pos' unless valid_pos?(pos)
        x,y=pos
        @rows[x][y]=piece
    end

    def add_piece(piece,pos)
        raise 'position not empty' unless empty?(pos)
        self[pos]=piece
    end

    def empty?(pos)
        self[pos].empty?
    end

    def valid_pos?(pos)
        pos.all? {|coord| coord.between?(0,7) }
    end

    def pieces
        @rows.flatten.reject {|piece| piece.empty?}
    end

    def dup
        new_board=Board.new(false)
        pieces.each do |p|
            p.class.new(p.color,new_board,p.pos)
        end
        new_board
    end

    def move_piece(turn_color,start_pos,end_pos)
        raise "There is no piece." if empty?(start_pos)

        piece=self[start_pos]
        raise "You cannot move opponent's piece" if piece.color != turn_color
        raise "You can move piece like that." if !piece.moves.include?(end_pos)
        raise "You cannot move into check." if !piece.valid_moves.include?(end_pos)
        
        move_piece!(start_pos,end_pos)
    end

    # move without performing checks
    def move_piece!(start_pos,end_pos)
        piece=self[start_pos]
        raise 'Piece cannot move like that' unless piece.moves.include?(end_pos)
        self[end_pos]=piece
        self[start_pos]=sentinel
        piece.pos=end_pos
        nil
    end

    def in_check?(color)
        king_pos=find_king(color).pos
        pieces.any? {|p| p.color!=color && p.moves.include?(king_pos)}
    end

    def checkmate?(color)
        return false unless in_check?(color)
        pieces.select {|p| p.color==color}.all? {|piece| piece.valid_moves.empty?}
    end

    private

    attr_reader :sentinel

    def fill_back_row(color)
        back_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

        i= (color==:white) ? 7 : 0
        back_pieces.each_with_index do |piece_class,j|
            piece_class.new(color,self,[i,j])
        end
    end

    def fill_pawns_row(color)
        i= (color==:white) ? 6 : 1
        8.times {|j| Pawn.new(color,self,[i,j])}
    end

    def make_starting_grid(fill_board)
        @rows=Array.new(8) {Array.new(8,sentinel)}
        return unless fill_board
        %i(white black).each do |color|
            fill_back_row(color)
            fill_pawns_row(color)
        end        
    end

    def find_king(color)
        king_piece=pieces.find {|p| p.color==color && p.is_a?(King)}
        king_piece || (raise 'King not found')
    end

end