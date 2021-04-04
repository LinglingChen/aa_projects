require_relative 'board'
require_relative 'human_player'

class Game

    attr_reader :board,:players,:display,:current_player

    def initialize
        @board=Board.new
        @display=Display.new(@board)
        @players={
            white : HumanPlayer.new(:white,@display)
            black : HumanPlayer.new(:black,@display)
        }
        @current_player=:white
    end

    def play
        until board.checkmate?(current_player)
        
            start_pos,end_pos=players[current_player].make_move(board)
            board.move_piece(current_player,start_pos,end_pos)

            swap_turn
        end

        display.render
        puts "#{current_player} is checked!"

        nil
    end

    private

    def swap_turn
        current_player= (current_player==:white) ? :black : :white
    end
end

if $PROGRAM_NAME == __FILE__
  Game.new.play
end