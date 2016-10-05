require_relative("../lib/frame")

class Game
  attr_accessor :current_frame

  def initialize
    @frames = []
    10.times do
      @frames << Frame.new
    end

    @current_frame = 1
  end

  def frame(frame_number)
    @frames[(frame_number-1)]
  end

  def frames
    @frames
  end

  def next_frame
    if current_frame == 10
      show_error('Cannot exceed 10th frame')
      {valid: false}
    else
      @current_frame += 1
      {valid: true}
    end
  end

  def show_error(input)
    puts input
  end
end