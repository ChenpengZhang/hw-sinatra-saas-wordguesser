require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
    if not session[:best]
      session[:best] = "invalid"
    end
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      status = @game.guess(letter)
      if status == false
        flash[:message] = "You have already used that letter."
      end
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    if not @game.word_with_guesses.include?('-')
      redirect '/win'
    elsif @game.wrong_guesses.length == 7
      redirect '/lose'
    end
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    if @game.word_with_guesses.include?('-')
      redirect '/show'
    elsif @game.word == ''
      redirect '/new'
    end
    if session[:best] == 'invalid'
      session[:best] = @game.wrong_guesses.length
    else
      session[:best] = [@game.wrong_guesses.length, session[:best]].min
    end
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    if @game.wrong_guesses.length < 7
      redirect '/show'
    end
    erb :lose # You may change/remove this line
  end
  
end
