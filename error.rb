class InvalidMoveError < StandardError
  attr_reader :object, :message

  def initialize(object)
    @object = object
    @message = "Invalid move!"
  end
end
