module HPBarHelper
  def maxhp
    @maxhp
  end

  def hp
    @hp
  end

  def hp_bar_remaining
    puts @hp
    puts @maxhp
    val = (@hp/@maxhp * 4.75).to_i
    val.between?(0, 4) ? val : 0
  end
end
