require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a[rand(26)] }
    @start_time = Time.now.to_f
  end

  def score
    end_time = Time.now.to_f
    attempt = params[:attempt]
    if attempt.nil?
      @message = "No attempt"
      @score = 0
    end
    start_time = params[:start_time].to_f
    elapsed_time = (end_time - start_time)
    letters = params[:letters]
    if attempt.chars.all? { |letter| attempt.chars.count(letter) <= letters.count(letter.upcase) }
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      response = URI.open(url).read
      data = JSON.parse(response)
      if data["found"]
        @score = ((attempt.size)**(2) * 10 / (5 + elapsed_time)).round(2)
        @message = "Congrats, #{attempt} is a valid word"
      else
        @message = "Sorry, #{attempt} is not a word"
        @score = 0
      end
    else
      @message = "Sorry, #{attempt} does not use the right letters"
      @score = 0
    end
  end
end
