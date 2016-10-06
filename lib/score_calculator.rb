class ScoreCalculator
  def calculate(options)
    {score: calculate_by_frame(options).values.inject(:+)}
  end

  def calculate_by_frame(options)
    frames = options[:frames]
    result = {}
    frames.each_with_index do | frame , index|
      frame_score = (frame.roll_1 + frame.roll_2.to_i)

      if frame.spare? && not_last_frame?(frames, index)
        spare_score = frames[(index +1)].roll_1
        result[(index + 1).to_s] = (spare_score + frame_score)
        puts (spare_score + frame_score)
        puts '+'
      elsif frame.strike? && not_last_frame?(frames, index)
        next_frame = frames[(index+1)]

        if next_frame.strike? && !next_frame.bonus
          following_frame = frames[(index+2)]
          result[(index + 1).to_s] = 10 + next_frame.roll_1 + next_frame.roll_2.to_i + following_frame.roll_1
          puts 10 + next_frame.roll_1 + next_frame.roll_2.to_i + following_frame.roll_1
          puts '+'
        end

        if next_frame.bonus || next_frame.miss? || next_frame.spare?
          result[(index + 1).to_s] = 10 + next_frame.roll_1 + next_frame.roll_2
          puts 10 + next_frame.roll_1 + next_frame.roll_2
          puts '+'
        end
      else
        puts frame_score
        puts '+'
        unless frame.bonus
          result[(index + 1).to_s] = frame_score
        end
      end
    end

    result
  end

  def not_last_frame?(frames, index)
    index != (frames.size - 1)
  end
end