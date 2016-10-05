require_relative("../lib/game")

describe Game do
  let(:game) {Game.new}

  it 'has 10 frames' do
    expect(game.frames.size).to eq 10
  end

  it 'tracks current frame' do
    expect(game.current_frame).to eq 1
  end

  it 'allows increasing the current frame' do
    game.next_frame
    expect(game.current_frame).to eq 2
  end

  it 'does not allow the frame to exceed 10th frame' do
    expect(game).to receive(:show_error).with('Cannot exceed 10th frame')

    10.times do
      game.next_frame
    end
  end
end