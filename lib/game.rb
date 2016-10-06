require_relative("../lib/frame")

class Game
  attr_accessor :current_frame

  def initialize
    @frames = []
    10.times do
      @frames << Frame.new
    end

    @bonus_frame = Frame.new
    @bonus_frame.bonus = true
    @current_frame = 1
  end

  def frame(frame_number)
    @frames[(frame_number-1)]
  end

  def update_frame(frame_number, frame)
    @frames[(frame_number-1)] = frame
  end

  def frames
    active_frames = @frames.select {|frame| frame.active}
    if bonus_frame.active
      active_frames << bonus_frame
      active_frames
    else
      active_frames
    end
  end

  def bonus_frame
    @bonus_frame
  end

  def bonus_frame=(bonus_frame)
    @bonus_frame = bonus_frame
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