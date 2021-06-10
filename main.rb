require 'sinatra'
require 'sinatra/reloader'
# require 'sinatra/flash'
require 'pry'
require 'bcrypt'
require 'pg'
require 'httparty'
# require_relative 'db/helpers.rb'
set :port, 4568



def run_sql(sql, params =[])
  db = PG.connect(dbname: 'gametracker')
  res = db.exec_params(sql, params)
  db.close
  return res
end

enable :sessions

def current_user
  if session[:user_id] == nil
    return {}
  end
  return run_sql("SELECT * FROM users WHERE id = #{session[:user_id]};")[0]
end


def logged_in?
  # puts "logged_in? called"
  # puts "session[:user_id]: #{session[:user_id]}"
  if session[:user_id] == nil
    puts "logged_in? false"
    return false
  else 
    puts "logged_in? true"
    return true
  end
end


# ------------------------------------User Controller------------------------------------
get '/' do
  erb(:index)
end

get '/signup' do
  erb(:sign_up)
end

post '/signup' do
  if params["user_name"] == "" || params["email"] == "" || params["password"] == ""
    redirect to '/signup'
  else 
    password = params["password"]
    password_digest = BCrypt::Password.create(password)
    puts password_digest
  
    sql = "INSERT INTO users (user_name,email,password_digest) VALUES ($1,$2,$3);"
    run_sql(sql, [
      params["user_name"],
      params["email"],
      password_digest
    ])
    redirect '/login'
  end 
end

get '/login' do
  erb(:login)
end

post '/login' do
  puts params["user_name"]
  users = run_sql("SELECT * FROM users WHERE user_name = $1", [params["user_name"]])
  # debug messages
  puts "users: #{users}"
  # puts users[0]["email"]
  # puts BCrypt::Password.create(params["password"])
  # puts BCrypt::Password.new(users[0]["password_digest"])
  if users.count > 0 && BCrypt::Password.new(users[0]["password_digest"]) == params["password"] 
    logged_in_user = users[0]
    session[:user_id] = logged_in_user["id"]
    puts "session[:user_id]: #{session[:user_id]}"
    games = run_sql("SELECT * FROM games where users_id = $1;", [logged_in_user["id"]])

    erb(:game_collection, {
      locals:{
        games: games
      }
    })
    
  else
    redirect '/'
  end
end

get '/session' do
    redirect "/login" unless logged_in?
    # puts "session[:user_id]: #{session[:user_id]}"
    games = run_sql("SELECT * FROM games where users_id = $1;", [session[:user_id]])
    erb(:game_collection, {
      locals:{
        games: games
      }
    })
end  


delete '/session' do
  session[:user_id] = nil # empty
  redirect '/'
end

# -------------------------Game Controller----------------------------------

get '/games' do

  erb(:game_collection)
end

get '/community' do

  games = run_sql("SELECT * FROM games g 
                  LEFT JOIN users u
                  ON g.users_id = u.id ;")

  # games = run_sql("SELECT * FROM games;")


  erb(:community, locals:{games: games})
end

get '/games/new' do
  erb(:new_game_form)
end

get '/games/:id' do

  id = params["id"]

  db = PG.connect(dbname: 'gametracker')
  puts params["id"]
  res = db.exec("SELECT * FROM games WHERE id = #{id};")
  db.close
  game = res[0]
  erb(:game_collection, locals:{game: game})
end

delete '/games/:id' do
  redirect '/login' unless logged_in? 
  sql = "DELETE FROM games WHERE id = #{params['id']};"
  run_sql(sql)
  redirect '/session'
end


post '/games' do
  redirect'/login' unless logged_in?

  if params["title"] == "" || params["year"] == "" || params["description"] == "" ||params["rating"] =="" || params["category"] == ""
    redirect to '/games/new'
  else
    sql = "INSERT INTO games (title,year,description,rating,category,users_id) VALUES ($1,$2,$3,$4,$5,$6);"
    run_sql(sql,[
    params['title'],
    params['year'].to_i,
    params['description'],
    params['rating'].to_i,
    params['category'],
    current_user()['id']
    ])

    games = run_sql("SELECT * FROM games where users_id = $1;", [session[:user_id]])
    erb(:game_collection, {
      locals:{
        games: games
      }
    })
  end
end

get'/games/:id/edit' do
  res = run_sql("SELECT * FROM games WHERE id = #{params["id"]};")
  
  game = res[0]
  erb(:edit_game_form, locals: {game: game})
  
end

put '/games/:id' do
  
  sql = "UPDATE games SET title = $1, year = $2, description = $3, rating=$4, category=$5 WHERE id = $6;"
  run_sql(sql,[params['title'],params['year'].to_i,params['description'],params['rating'].to_i, params['category'],params['id']])
  # redirect
  redirect "/session"
end


get '/search' do
  puts params['search']
  url="http://api.rawg.io/api/games?key=22678094a7b7404088bff644934da739&search=#{params['search']}"

  res = HTTParty.get(url)
  erb(:search, locals:{
    games: res["results"]
  })

end



