require 'bcrypt'
require 'sqlite3'
require 'slim'
require 'sinatra'
enable :sessions

get('/') do
    slim(:index)
end

post('/') do
    slim(:index)
end

get('/thank') do
    slim(:thank)
end

get('/kundvagn') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    

    ses_id = session[:id].first["id"].to_i
    @tot_pris = db.execute("SELECT sum(total_price) FROM buy_item WHERE buy_id = ?", ses_id).first["sum(total_price)"].to_i
    show = db.execute("SELECT product_id, number_items, total_price, name FROM buy_item WHERE buy_id = ?", ses_id )

    slim(:kundvagn, locals:{show:show})
end

post('/kundvagn') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true

    ses_id = session[:id].first["id"].to_i

    result = db.execute("DELETE FROM buy_item WHERE buy_id = ?", ses_id)

    redirect('/thank')
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
    result = db.execute("SELECT user_name, hash_pass FROM user WHERE user.user_name=?", params["usr_name"])
    if result.length > 0 && BCrypt::Password.new(result.first["hash_pass"]) == params["usr_pass"]
        
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
        redirect("/error")
    end
end

post('/prod1_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "banan"
    prod_num = params["drop1"]
    prod_id = session[:id].first["id"].to_i
    prod_price = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]
    prod_nr_add = prod_price.to_i * prod_num.to_i

    id_name = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", prod_id, id_name, prod_num, prod_nr_add, prod)

    redirect('/kundvagn')
end
post('/prod2_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "sten"
    prod_num = params["drop2"]
    prod_id = session[:id].first["id"].to_i
    prod_price = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    prod_nr_add = prod_price.to_i * prod_num.to_i

    id_name = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", prod_id, id_name, prod_num, prod_nr_add, prod)

    redirect('/kundvagn')
end
post('/prod3_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "bord"
    prod_num = params["drop3"]
    prod_id = session[:id].first["id"].to_i
    prod_price = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    prod_nr_add = prod_price.to_i * prod_num.to_i

    id_name = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", prod_id, id_name, prod_num, prod_nr_add, prod)

    redirect('/kundvagn')
end
post('/prod4_sub') do
    db = SQLite3::Database.new("db/webbshop.db") 
    db.results_as_hash = true
    nollan = 0
    prod = "dator"
    prod_num = params["drop4"]
    prod_id = session[:id].first["id"].to_i
    prod_price = db.execute("SELECT price FROM product WHERE name = ?", prod).first["price"]

    prod_nr_add = prod_price.to_i * prod_num.to_i

    id_name = db.execute("SELECT id FROM product WHERE name = ?", prod).first["id"]
    nagn = db.execute("INSERT INTO buy_item (buy_id, product_id, number_items, total_price, name) VALUES (?, ?, ?, ?, ?)", prod_id, id_name, prod_num, prod_nr_add, prod)

    redirect('/kundvagn')
end

post("/logout") do
    session[:username] = nil
    redirect("/")
end

get("/error") do 
    slim(:error)
end