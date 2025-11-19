
from flask import Flask, request, jsonify, send_from_directory
import sqlite3, os
from datetime import date, datetime

DB='lifelink.db'
app=Flask(__name__, static_folder='frontend', static_url_path='/frontend')

def get_db():
    conn=sqlite3.connect(DB)
    conn.row_factory=sqlite3.Row
    conn.execute('PRAGMA foreign_keys=ON;')
    return conn

@app.route('/')
def index():
    return send_from_directory('frontend', 'login.html')

@app.route('/login', methods=['POST'])
def login():
    data=request.json or {}
    username=data.get('username'); password=data.get('password')
    conn=get_db()
    row=conn.execute('SELECT * FROM admin WHERE username=?',(username,)).fetchone()
    if row and row['password']==password:
        return jsonify({'token':'admintoken123','username':username})
    return jsonify({'error':'invalid'}),401

@app.route('/dashboard')
def dashboard():
    return send_from_directory('frontend','dashboard.html')

@app.route('/donors', methods=['GET','POST'])
def donors():
    conn=get_db()
    if request.method=='GET':
        rows=conn.execute('''SELECT d.*, bg.group_name as bg, h.name as hospital_name
                              FROM donor d LEFT JOIN blood_group bg ON d.bg_id=bg.bg_id
                              LEFT JOIN hospital h ON d.hospital_id=h.hospital_id
                              ORDER BY d.registered_at DESC''').fetchall()
        return jsonify([dict(r) for r in rows])
    data=request.json or {}
    cur=conn.execute('INSERT INTO donor(name,age,gender,phone,email,bg_id,organs_available,last_donation,hospital_id) VALUES(?,?,?,?,?,?,?,?,?)',
                     (data.get('name'), data.get('age'), data.get('gender'), data.get('phone'), data.get('email'),
                      data.get('bg_id'), data.get('organs_available'), data.get('last_donation'), data.get('hospital_id')))
    conn.commit()
    return jsonify({'donor_id':cur.lastrowid}),201

@app.route('/patients', methods=['GET','POST'])
def patients():
    conn=get_db()
    if request.method=='GET':
        rows=conn.execute('SELECT * FROM patient').fetchall()
        return jsonify([dict(r) for r in rows])
    data=request.json or {}
    cur=conn.execute('INSERT INTO patient(name,age,gender,phone,email,required_bg,organ_needed,hospital_id) VALUES(?,?,?,?,?,?,?,?)',
                     (data.get('name'), data.get('age'), data.get('gender'), data.get('phone'), data.get('email'),
                      data.get('required_bg'), data.get('organ_needed'), data.get('hospital_id')))
    conn.commit()
    return jsonify({'patient_id':cur.lastrowid}),201

@app.route('/hospitals')
def hospitals():
    conn=get_db()
    rows=conn.execute('SELECT * FROM hospital').fetchall()
    return jsonify([dict(r) for r in rows])

@app.route('/blood_groups')
def blood_groups():
    conn=get_db()
    rows=conn.execute('SELECT * FROM blood_group').fetchall()
    return jsonify([dict(r) for r in rows])

@app.route('/organs')
def organs():
    conn=get_db()
    rows=conn.execute('SELECT * FROM organ').fetchall()
    return jsonify([dict(r) for r in rows])

@app.route('/reports/stock')
def stock():
    conn=get_db()
    blood=conn.execute('''SELECT h.name as hospital, bg.group_name as blood_group, bi.units
                          FROM blood_inventory bi JOIN hospital h ON bi.hospital_id=h.hospital_id
                          JOIN blood_group bg ON bi.bg_id=bg.bg_id''').fetchall()
    organs=conn.execute('''SELECT h.name as hospital, oi.organ_name, oi.availability
                           FROM organ_inventory oi JOIN hospital h ON oi.hospital_id=h.hospital_id''').fetchall()
    return jsonify({'blood':[dict(r) for r in blood],'organs':[dict(r) for r in organs]})

@app.route('/requests', methods=['GET','POST'])
def requests_route():
    conn=get_db()
    if request.method=='GET':
        rows=conn.execute('''SELECT r.*, p.name as patient_name, h.name as hospital_name
                              FROM request_table r LEFT JOIN patient p ON r.patient_id=p.patient_id
                              LEFT JOIN hospital h ON r.hospital_id=h.hospital_id
                              ORDER BY r.request_date DESC''').fetchall()
        return jsonify([dict(r) for r in rows])
    data=request.json or {}
    cur=conn.execute('INSERT INTO request_table(patient_id,hospital_id,type,bg_required,organ_required,units_required,request_date) VALUES(?,?,?,?,?,?,?)',
                     (data.get('patient_id'), data.get('hospital_id'), data.get('type'), data.get('bg_required'),
                      data.get('organ_required'), data.get('units_required',1), data.get('request_date')))
    conn.commit()
    return jsonify({'req_id':cur.lastrowid}),201

@app.route('/requests/<int:req_id>/matches')
def matches(req_id):
    conn=get_db()
    req=conn.execute('SELECT * FROM request_table WHERE req_id=?',(req_id,)).fetchone()
    if not req:
        return jsonify([])
    matches=[]
    if req['type']=='BLOOD':
        bg=req['bg_required']
        donors=conn.execute('''SELECT d.*, bg.group_name as bg_name, h.name as hospital_name FROM donor d
                                LEFT JOIN blood_group bg ON d.bg_id=bg.bg_id LEFT JOIN hospital h ON d.hospital_id=h.hospital_id''').fetchall()
        for d in donors:
            if d['bg_name']==bg:
                matches.append(dict(d))
    else:
        organ=req['organ_required']
        donors=conn.execute('SELECT d.*, h.name as hospital_name FROM donor d LEFT JOIN hospital h ON d.hospital_id=h.hospital_id').fetchall()
        for d in donors:
            if d['organs_available'] and organ.lower() in d['organs_available'].lower():
                matches.append(dict(d))
    return jsonify(matches)

if __name__=='__main__':
    print('USING DB:', os.path.abspath(DB))
    app.run(debug=True)
