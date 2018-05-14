require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(8) { ("a".."z").to_a.sample.upcase }
  end


  def score
    @end_time = Time.now.strftime('%s')

    url = "https://wagon-dictionary.herokuapp.com/#{params[:attempt]}"
    response = open(url)
    @json = JSON.parse(response.read)

    @result = { time: (@end_time.to_i - params[:start_time].to_i), message: "The given word is not in the grid. Pay attention!", score: 0 }

    return @result unless grid_v_attempt(params[:attempt], params[:letters])

    if @json["found"]
      @result[:message] = "Well done!"
      @result[:score] = ((params[:attempt].length ** 3) / @result[:time])
    else
      @result[:message] = "The given word is not an English word, you dummy!"
    end
    return @result

  end

  def grid_v_attempt(attempt, grid)
    attempt_hash = Hash.new(0)
    new_attempt = attempt.upcase.gsub(/\W/, '').split('')
    new_attempt.each { |caracter| attempt_hash[caracter] += 1 }
    grid_hash = Hash.new(0)
    new_grid = grid.upcase.gsub(/\W/, '').split('')
    new_grid.each { |caracter| grid_hash[caracter] += 1 }
    attempt_hash.delete_if { |key, value| value <= grid_hash[key] }
    attempt_hash == {}
  end
end
