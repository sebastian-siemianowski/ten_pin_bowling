require_relative("../lib/score_calculator")
require_relative("../lib/frame")

describe ScoreCalculator do
  let(:calculator){ScoreCalculator.new}
  let(:frame){Frame.new}
  let(:missed_frame){ m_frame = frame.dup ; m_frame.roll_1 = 5 ; m_frame.roll_2 = 3; m_frame }
  let(:missed_frame2){ m_frame = frame.dup ; m_frame.roll_1 = 3 ; m_frame.roll_2 = 3; m_frame }
  let(:missed_frame3){ m_frame = frame.dup ; m_frame.roll_1 = 3 ; m_frame.roll_2 = 0; m_frame }
  let(:spare_frame){ s_frame = frame.dup ; s_frame.roll_1 = 5 ; s_frame.roll_2 = 5 ; s_frame }
  let(:spare_frame2){ s_frame = frame.dup ; s_frame.roll_1 = 3 ; s_frame.roll_2 = 7 ; s_frame }
  let(:strike_frame){ str_frame = frame.dup ; str_frame.roll_1 = 10 ; str_frame }
  let(:bonus_frame) {b_frame = frame.dup ; b_frame.roll_1 = 6 ; b_frame.bonus = true; b_frame}
  let(:bonus_frame2) {b_frame = frame.dup ; b_frame.roll_1 = 10 ; b_frame.bonus = true; b_frame}
  let(:bonus_frame3) {b_frame = frame.dup ; b_frame.bonus = true; b_frame.roll_1 = 10 ; b_frame.roll_2 = 10; b_frame}

  it 'calculates series of frames' do
    options = {frames: [missed_frame,missed_frame]}
    expect(calculator.calculate(options)).to eq ({score: 16})
  end

  it 'scores a spare by adding 10 to the first roll of the next turn' do
    options = {frames: [spare_frame, missed_frame]}
    expect(calculator.calculate_by_frame(options)).to eq({'1' => 15, '2' => 8})
  end

  it 'properly scores multiple consecutive spares' do
    options = {frames: [spare_frame, spare_frame, spare_frame, spare_frame]}
    expect(calculator.calculate(options)).to eq ({score: 55})
  end

  it 'scores a strike by adding 10 to both rolls of the next turn' do
    options = {frames: [strike_frame, missed_frame]}
    expect(calculator.calculate_by_frame(options)).to eq({'1' => 18, '2' => 8})
  end

  it 'adds the bonus to the last turn if a spare is rolled' do
    frames = []
    9.times do
      frames << missed_frame2
    end

    frames << spare_frame
    frames << bonus_frame
    options = {frames: frames}

    expect(calculator.calculate(options)).to eq ({score: 70})
  end

  it 'scores an entire game of misses correctly' do
    frames = []

    10.times do
      frames << missed_frame3
    end

    options = {frames: frames}

    expect(calculator.calculate(options)).to eq({score: 30})
  end

  it 'scores an entire game of spares correctly' do
    frames = []

    10.times do
      frames << spare_frame2
    end

    frames << bonus_frame2

    options = {frames: frames}
    expect(calculator.calculate(options)).to eq({score: 137})
  end

  it 'scores consecutive strikes correctly' do
    frames = []

    10.times do
      frames << strike_frame
    end

    frames << bonus_frame3

    options = {frames: frames}

    expect(calculator.calculate(options)).to eq({score: 300})
  end

  it 'scores a game of consecutive strikes ending in a miss correctly' do
    frames = []

    9.times do
      frames << strike_frame
    end

    frames << missed_frame

    options = {frames: frames}

    expect(calculator.calculate(options)).to eq({score: 261})
  end

end