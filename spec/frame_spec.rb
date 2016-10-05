require_relative("../lib/frame")

describe Frame do
  let(:frame) {Frame.new}

  it 'allows setting roll 1 pin count' do
    frame.roll_1 = 5
    expect(frame.roll_1).to eq 5
  end

  it 'displays error message if roll 2 is inserted before roll 1' do
    expect(frame).to receive(:show_error_message).with('Roll 1 pin count needs to be inserted first')
    frame.roll_2 = 7
  end

  it 'allows setting roll 2 pin count' do
    frame.roll_1 = 3
    frame.roll_2 = 7
    expect(frame.roll_2).to eq 7
  end

  it 'determines if strike is present' do
    frame.roll_1 = 10
    expect(frame.strike?).to eq true
  end

  it 'determines if spare is present' do
    frame.roll_1 = 3
    frame.roll_2 = 7
    expect(frame.spare?).to eq true
  end

  it 'displays error message if roll 1 pin count is greater than 10' do
    expect(frame).to receive(:show_error_message).with('Please provide correct number of pins for roll 1 that is less or equal 10')
    frame.roll_1 = 11
  end

  it 'displays error message if roll 2 is being set even though there was a strike in roll 1' do
    expect(frame).to receive(:show_error_message).with('Roll 1 pin count needs to be inserted first')
    frame.roll_2 = 5
  end

  it 'displays error message if total pin count exceeds 10' do
    expect(frame).to receive(:show_error_message).with('Number of pins cannot exceed 10')
    frame.roll_1 = 7
    frame.roll_2 = 4
  end

  it 'enables marking the frame as finalized' do
    frame.finalized = true
    expect(frame.finalized).to eq true
  end
end