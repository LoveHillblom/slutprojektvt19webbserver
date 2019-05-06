require 'bcrypt'
require 'sqlite3'
require 'slim'
require 'sinatra'
enable :sessions

get('/') do
    slim(:index)
end

get('/kundvagn') do
    slim(:skapa)
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

        nameid = db.execute("SELECT id FROM user WHERE user_name=?", session[:username])

        session[:nameid] = nameid
        redirect("/")
    else
        redirect("/")
    end
end

post('/prod1_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod1_pris = 12
    Add_am = params["drop1"]
    #db.execute("SELECT buy_item.product_id, user.id FROM buy_item INNER JOIN user ON buy_item.product_id = user.id")
    #result1=db.execute("SELECT product_id FROM buy_item WHERE user.id = 1") 
    
    #bid = db.execute("SELECT buy_id FROM buy_item WHERE buy_id=?", nameid)
    #bid = db.execute("SELECT buy_item.buy_id, user.id FROM buy_item INNER JOIN user ON buy_item.buy_id = user.id WHERE user.id=4")
    db.execute("SELECT buy.usr_acct_id, user.id FROM buy INNER JOIN user ON buy.usr_acct_id = user.id")
    db.execute("SELECT buy_item.buy_id, buy.usr_acct_id FROM buy_item INNER JOIN buy ON buy_item.buy_id = buy.usr_acct_id")
    kok = session[:username]

    bid = db.execute("SELECT buy_id FROM buy_item WHERE user.user_name=?", kok)

    tot_pris = db.execute("SELECT total_price FROM buy_item WHERE buy_id=?", nameid)

    blabla = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items) VALUES (?, ?, ?)", [bid, 1, Add_am])
    if tot_pris == nil 
        db.execute("INSERT INTO buy_item (total_price) VALUES (?)", [nollan])    
    else
        db.execute("UPDATE buy_item SET total_price (?) WHERE buy_id=?",[tot_pris + prod1_pris, nameid])
    end
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