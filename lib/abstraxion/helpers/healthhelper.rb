module HPBarHelper
  def maxhp
    @maxhp
  end

  def hp
    @hp
  end

  def hp_bar_remaining
    val = (@hp/@maxhp * 4.75).to_i
    val.between?(0, 4) ? val : 0
  end
end
