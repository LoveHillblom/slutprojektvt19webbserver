require 'bcrypt'
require 'sqlite3'
require 'slim'
require 'sinatra'
enable :sessions

get('/') do
    slim(:index)
end

get('/kundvagn') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    

    koka = session[:id].first["id"].to_i
    @faen = db.execute("SELECT sum(total_price) FROM buy_item WHERE buy_id = ?", koka).first["sum(total_price)"].to_i
    show = db.execute("SELECT product_id, number_items, total_price, name FROM buy_item WHERE buy_id = ?", koka )

    slim(:kundvagn, locals:{show:show})
end

post('/kundvagn') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true

    kamal = session[:id].first["id"].to_i

    result = db.execute("DELETE FROM buy_item WHERE buy_id = ?", kamal)

    redirect('/')
end

get('/reg') do
    slim(:skapa)
end

post('/skapa_anv') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    Anv_namn = params["usr_name_p"]
    Anv_pass = BCrypt::Password.create(params["usr_pass_p"])
    session[:username] = Anv_namn
    session[:createlogin] = "login"
    result = db.execute("INSERT INTO user (user_name, hash_pass) VALUES (?, ?)", [Anv_namn, Anv_pass])
    redirect("/")
end

post("/inlogg_submit") do
    db = SQLite3::Database.new("db/webbshop.db")
    db.results_as_hash = true
    koknen = db.execute("SELECT user_name, hash_pass FROM user WHERE user.user_name=?", params["usr_name"])
    if koknen.length > 0 && BCrypt::Password.new(koknen.first["hash_pass"]) == params["usr_pass"]
        
        usr_name = db.execute("SELECT user_name FROM user")
        usr_name.each do |row|
            usr_name = row['user_name']
        end

        session[:createlogin] = "login"
        session[:username] = usr_name

        session[:id] = db.execute("SELECT id FROM user WHERE user_name=?", usr_name)
        nameid = session[:id].first["id"].to_i
        redirect("/")
    else
        redirect("/")
    end
end

post('/prod1_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "banan"
    add = params["drop1"]
    kok = session[:id].first["id"].to_i
    lonmat = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]
    matlon = lonmat.to_i * add.to_i

    dome = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", kok, dome, add, matlon, prod)

    redirect('/kundvagn')
end
post('/prod2_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "sten"
    add = params["drop2"]
    kok = session[:id].first["id"].to_i
    lonmat = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    matlon = lonmat.to_i * add.to_i

    dome = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", kok, dome, add, matlon, prod)

    redirect('/kundvagn')
end
post('/prod3_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "bord"
    add = params["drop3"]
    kok = session[:id].first["id"].to_i
    lonmat = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    matlon = lonmat.to_i * add.to_i

    dome = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", kok, dome, add, matlon, prod)

    redirect('/kundvagn')
end
post('/prod4_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "dator"
    add = params["drop4"]
    kok = session[:id].first["id"].to_i
    lonmat = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    matlon = lonmat.to_i * add.to_i

    dome = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", kok, dome, add, matlon, prod)

    redirect('/kundvagn')
end

post("/logout") do
    session[:username] = nil
    redirect("/")
end
    
post('/prod2_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    Add_am2 = params["drop2"]

    result = db.execute("SELECT product_id FROM buy_item WHERE id = 2")
end

post('/prod3_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    Add_am3 = params["drop3"]

    result = db.execute("SELECT product_id FROM buy_item WHERE id = 3")
end

post('/prod4_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    Add_am4 = params["drop4"]

    result = db.execute("SELECT product_id FROM buy_item WHERE id = 4")
end