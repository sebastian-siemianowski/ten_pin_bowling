class Frame

  attr_accessor :finalized, :bonus

  def initialize
    @finalized = false
  end

  def show_error_message(message)
    puts(message)
  end

  def roll_1
    @roll_1
  end

  def roll_2
    @roll_2
  end

  def roll_1=(number_of_pins)
    validation_result = validate_roll_1(number_of_pins)
    if validation_result[:valid]
      @roll_1 = number_of_pins.to_i
      {valid: true}
    else
      validation_result
    end
  end

  def roll_2=(number_of_pins)
    validation_result = validate_roll_2(number_of_pins)
    if validation_result[:valid]
      @roll_2 = number_of_pins.to_i
      {valid: true}
    else
      validation_result
    end
  end

  def strike?
    roll_1 == 10
  end

  def spare?
    !roll_2.nil? && (roll_1 + roll_2) == 10
  end

  def miss?
    (roll_1 + roll_2.to_i) < 10
  end

  private

  def validate_roll_1(input)
    unless is_a_positive_number?(input)
      show_positive_number_error_message
      return {valid: false}
    end

    if input.to_i > 10
      show_error_message('Please provide correct number of pins for roll 1 that is less or equal 10')
      return {valid: false}
    end

    {valid: true}
  end

  def validate_roll_2(input)
    unless is_a_positive_number?(input)
      show_positive_number_error_message
      return {valid: false}
    end

    unless roll_1
      show_error_message('Roll 1 pin count needs to be inserted first')
      return {valid: false}
    end

    if (roll_1 + input) > 10 && !bonus
      show_error_message('Number of pins cannot exceed 10')
      return {valid: false}
    end

    {valid: true}
  end

  def show_positive_number_error_message
    show_error_message('Please provide positive number')
  end

  def is_a_positive_number?(input)
    if !/\A\d+\z/.match(input.to_s)
      false
    else
      true
    end
  end
end