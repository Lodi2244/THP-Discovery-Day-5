require 'httparty'

class Game
  attr_accessor :word, :displayed_word, :guesses, :right_guesses
  
  def initialize(word)
    @word = self.class.select_word
    @displayed_word = []
    @right_guesses = []
    @wrong_guesses_count = 0
  end 

  def displayed_word(guesses)
    @word.each_char.with_index do |char, index|
      if guesses.include?(char)
        @right_guesses.push(char)
        @displayed_word[index] = char
      else
        @displayed_word[index] = "-"
      end 
      @displayed_word
    end 
    @wrong_guesses_count = guesses.count - @right_guesses.uniq.count
    @displayed_word
  end 

  def word_complete?
    # add a method to check if the displayed word is complete
  end 

  def hung?
    @wrong_guesses_count == 11
  end 


  def wrong_guesses_count
    @wrong_guesses_count
  end 

  def self.select_word
    word_length = rand(3..6)
    response = HTTParty.get("https://random-word-api.vercel.app/api?words=1&length=#{word_length}")
    response.first
  end 
end 
