class Board
  attr_accessor :cups,:name1,:name2

  def initialize(name1, name2)
    @cups=Array.new(14) 
    @name1=name1
    @name2=name2
    place_stones   
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |el,i|
      if i==6 || i==13
        @cups[i]=[]
      else
        @cups[i]=[:stone, :stone, :stone, :stone]
      end
    end
  end

  def valid_move?(start_pos)
    if start_pos>14
      raise "Invalid starting cup"
    elsif @cups[start_pos].empty?
      raise "Starting cup is empty"
    else
      return true
    end
  end

  def make_move(start_pos, current_player_name)
    stones_to_distribute=@cups[start_pos].length
    opponent_store= current_player_name==name1 ? 13:6
    @cups[start_pos]=[]
    index=start_pos
    until stones_to_distribute==0
      index+=1
      ending_cup_idx=index%14
      if ending_cup_idx !=opponent_store
        @cups[ending_cup_idx]<<:stone 
        stones_to_distribute-=1
      end
    end
    render
    next_turn(ending_cup_idx)

  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if ending_cup_idx==6 || ending_cup_idx==13
      return :prompt
    elsif  @cups[ending_cup_idx].length==1
      return :switch
    else
      return ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? {|el| el.empty?} || @cups[7..12].all? {|el| el.empty?}
  end

  def winner
    if @cups[6].count>@cups[13].count
      return @name1
    elsif @cups[6].count<@cups[13].count
      return @name2
    else
      return :draw  
    end
  end
end
