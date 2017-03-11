require_relative '../sliding_piece'
require_relative '../stepping_piece'
require_relative '../board'
require 'byebug'

class Piece

  attr_reader :symbol, :color, :opponent_color
  attr_accessor :board, :current_position

  def self.dup(piece)
    if piece.is_a?(NullPiece)
      new_piece = piece
    else
      new_piece = piece.dup
      new_piece.current_position = piece.current_position.dup
    end

    new_piece
  end

  def initialize(current_position = nil, color = nil)
    @current_position = current_position
    @color = color
    @opponent_color = color == :white ? :black : :white if color
  end

  def increment_position(position, delta)
    delta_row, delta_col = delta
    pos_row, pos_col = position

    [delta_row + pos_row, delta_col + pos_col]
  end

  def can_move?(end_pos)
    moves.include?(end_pos)
  end

  def move_into_check?(end_pos)
    board_copy = board.dup
    board_copy.move_piece!(current_position, end_pos)
    board_copy.in_check?(color)
  end

  def no_check_move?(pos)
    valid_moves.include?(pos)
  end

  def pawn_promotion_necessary?
    false
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def valid_moves?
    valid_moves.length > 0
  end

  def valid_move?(pos)
    return false unless pos && Board.in_bounds?(pos)
    return false if board[pos].color == self.color

    true
  end

end
