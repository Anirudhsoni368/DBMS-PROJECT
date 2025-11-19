
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS hospital (
    hospital_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    phone TEXT,
    primary_color TEXT DEFAULT '#0d6efd',
    secondary_color TEXT DEFAULT '#198754'
);

CREATE TABLE IF NOT EXISTS blood_group (
    bg_id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_name TEXT UNIQUE NOT NULL,
    rhesus TEXT
);

CREATE TABLE IF NOT EXISTS organ (
    organ_id INTEGER PRIMARY KEY AUTOINCREMENT,
    organ_name TEXT UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS donor (
    donor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER,
    gender TEXT,
    phone TEXT,
    email TEXT,
    bg_id INTEGER,
    organs_available TEXT,
    last_donation DATE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hospital_id INTEGER,
    FOREIGN KEY (bg_id) REFERENCES blood_group(bg_id),
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
);

CREATE TABLE IF NOT EXISTS patient (
    patient_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER,
    gender TEXT,
    phone TEXT,
    email TEXT,
    required_bg TEXT,
    organ_needed TEXT,
    hospital_id INTEGER,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
);

CREATE TABLE IF NOT EXISTS blood_inventory (
    inv_id INTEGER PRIMARY KEY AUTOINCREMENT,
    hospital_id INTEGER,
    bg_id INTEGER,
    units INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id),
    FOREIGN KEY (bg_id) REFERENCES blood_group(bg_id)
);

CREATE TABLE IF NOT EXISTS organ_inventory (
    organ_inv_id INTEGER PRIMARY KEY AUTOINCREMENT,
    hospital_id INTEGER,
    organ_name TEXT,
    availability INTEGER DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
);

CREATE TABLE IF NOT EXISTS request_table (
    req_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id INTEGER,
    hospital_id INTEGER,
    type TEXT CHECK(type IN ('BLOOD','ORGAN')) NOT NULL,
    bg_required TEXT,
    organ_required TEXT,
    units_required INTEGER DEFAULT 1,
    status TEXT CHECK(status IN ('PENDING','APPROVED','REJECTED')) DEFAULT 'PENDING',
    request_date DATE,
    processed_at TIMESTAMP,
    processed_by TEXT,
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
);

-- admin table
CREATE TABLE IF NOT EXISTS admin (
    admin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE,
    password TEXT
);
