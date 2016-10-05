require_relative("../lib/game")

describe Game do
  let(:game) {Game.new}

  it 'has 10 frames' do
    expect(game.frames.size).to eq 10
  end
end