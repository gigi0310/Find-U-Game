def run_sql(sql, params =[])
    puts ("ENV['DATABASE_URL'] #{ENV['DATABASE_URL']}") 
    db = PG.connect(ENV['DATABASE_URL'])
    # db = PG.connect(dbname: 'gametracker')
    res = db.exec_params(sql, params)
    db.close
    return res
end


