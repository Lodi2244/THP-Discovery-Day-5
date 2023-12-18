require 'sinatra/base'
require 'sinatra/flash'
require './lib/game.rb'

class HangmanApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  configure do
    use Rack::Session::Cookie,
        expire_after: 30000,        
        secret:       'secret'
  end
  
  get '/' do
    session[:game] ||= Game.new(Game.select_word)
    @game = session[:game]
    session[:guesses] ||= []
    @guesses = session[:guesses]
    session[:displayed_word] ||= @game.displayed_word([]) 
    @displayed_word = session[:displayed_word]
    session[:wrong_guesses_count] ||= 0
    @wrong_guesses_count = session[:wrong_guesses_count]
    @win = @game.word_complete?
    @lose = @game.hung?
    
    redirect '/win' if @win
    redirect '/lose' if @lose 

    erb :home
  end

  post '/guess' do
    guesses = session[:guesses].push(params[:guess])
    session[:displayed_word] = session[:game].displayed_word(guesses) 
    session[:wrong_guesses_count] = session[:game].wrong_guesses_count
    
    redirect '/'

  end 

  get '/win' do 
    session.clear
    erb :win
  end 

  get '/lose' do 
    session.clear
    erb :lose
  end 
end 


