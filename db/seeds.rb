# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Movie.create(
#   title: "Wonder Woman 1984",
#   overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s",
#   poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg",
#   rating: 6.9
#   )
# Movie.create(
#   title: "The Shawshank Redemption",
#   overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison",
#   poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
#   rating: 8.7
#   )
# Movie.create(
#   title: "Titanic",
#   overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.",
#   poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
#   rating: 7.9
#   )
# Movie.create(
#   title: "Ocean's Eight",
#   overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.",
#   poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg",
#   rating: 7.0
#   )
# 10.times do |i|
#   puts "Importing movies from page #{i + 1}"
#   movies = JSON.parse(URI.open("#{url}?page=#{i + 1}").read)["results"]
#   movies.each do |movie|
#     puts "Creating #{movie["title"]}"
#     base_poster_url = "https://image.tmdb.org/t/p/original"
#     Movie.create(
#       title: movie["title"],
#       overview: movie["overview"],
#       poster_url: "#{base_poster_url}#{movie["backdrop_path"]}",
#       rating: movie["vote_average"]
#     )
#   end
# end
require "open-uri"
require "json"
require 'net/http'

tmdb_apikey = ENV['TMDB_API']
tmdb_accesstoken = ENV['TMDB_ACESSTOKEN']

puts "Cleaning up database..."
puts "🍿 Destroying movies..."
Movie.destroy_all
puts "Movies destroyed 🎬"
puts "Database cleaned"

# # Define the url
# url = URI("https://api.themoviedb.org/3/discover/movie?api_key==#{tmdb_apikey}&page=1")
# # Create HTTP object with SSL enabled
# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true
# # Create the GET request
# request = Net::HTTP::Get.new(url)
# request["accept"] = 'application/json'
# # Set authorization header with access token
# access_token = tmdb_accesstoken
# request["Authorization"] = "Bearer #{access_token}"
# # Send request and receive the response
# response = http.request(request)
# # Parse the JSON response
# movies_data = JSON.parse(response.body)
# puts "📽 Creating movies..."
# # Iterate over data and create movies
# movies_data["results"].each do |movie|
#   puts movie["title"]
# end

url = URI("https://api.themoviedb.org/3/movie/top_rated?api_key=#{tmdb_apikey}&page=1")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["accept"] = 'application/json'
access_token = tmdb_accesstoken
request["Authorization"] = "Bearer #{access_token}"

response = http.request(request)
movies_data = JSON.parse(response.body)
total_pages = movies_data["total_pages"]
movie_count = 0

puts "📽 Creating movies..."
# Iterate over all pages of results
(1..total_pages).each do |page|
  url = URI("https://api.themoviedb.org/3/movie/top_rated?api_key=#{tmdb_apikey}&page=#{page}")
  request = Net::HTTP::Get.new(url)
  request["accept"] = 'application/json'
  request["Authorization"] = "Bearer #{access_token}"
  response = http.request(request)
  movies_data = JSON.parse(response.body)

  # Iterate over movies on the current page
  movies_data["results"].each do |movie|
    puts movie["title"]
    movie_count += 1
    # Create or save the movie record in your Rails app here
    # ...
  end
end

puts "#{movie_count} movies created! 🥤"
