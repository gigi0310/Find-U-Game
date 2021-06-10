def run_sql(sql, params =[])
    db = PG.connect(dbname: 'gametracker')
    res = db.exec_params(sql, params)
    db.close
end


