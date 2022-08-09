class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @word_with_guesses = '-' * word.length
  end

  def guess(letter)
    if letter == '' or not letter =~ /[a-z|A-Z]/i or letter == nil 
      raise ArgumentError
    end
    letter = letter.downcase
    if @guesses.include?(letter) or @wrong_guesses.include?(letter)
      return false
    end
    if @word.include?(letter)
      @guesses = @guesses + letter
      ptr = 0
      word.split("").each do |lt|
        if lt == letter
          word_with_guesses[ptr] = letter
        end
        ptr += 1
      end
      return true
    end
    @wrong_guesses = @wrong_guesses + letter
    return true
  end

  def check_win_or_lose
    if wrong_guesses.length >= 7
      return :lose
    elsif guesses.length == word.length
      return :win
    end
    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
