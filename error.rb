class InvalidMoveError < StandardError
  attr_reader :message

  def initialize(message = nil)
    @message ||= "Invalid move!"
  end
end
