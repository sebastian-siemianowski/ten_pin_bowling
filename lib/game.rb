require_relative("../lib/frame")

class Game
  def initialize
    @frames = []
    10.times do
      @frames << Frame.new
    end
  end

  def frame(frame_number)
    @frames[(frame_number-1)]
  end

  def frames
    @frames
  end
end