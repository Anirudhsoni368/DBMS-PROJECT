
import sqlite3, os
DB='lifelink.db'
def run(path, conn):
    with open(path,'r') as f:
        conn.executescript(f.read())
if __name__=='__main__':
    here=os.path.dirname(__file__)
    conn=sqlite3.connect(os.path.join(here, DB))
    conn.execute('PRAGMA foreign_keys=ON;')
    run(os.path.join(here,'schema.sql'), conn)
    run(os.path.join(here,'sample.sql'), conn)
    conn.commit()
    conn.close()
    print('Initialized', DB)
