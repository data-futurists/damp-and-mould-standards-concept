import sqlite3
import os

def create_database_connection():
    """Create and return a database connection"""
    os.makedirs('database', exist_ok=True)
    return sqlite3.connect('database/damp_and_mould.db')

def execute_sql_script(conn, script_path):
    """Execute SQL script from file"""
    try:
        with open(script_path, 'r') as sql_file:
            sql_script = sql_file.read()
        print(f"Executing SQL script from {script_path}:")
        print(sql_script)
        conn.executescript(sql_script)
        conn.commit()
        return True
    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        print(f"Error occurred in file: {script_path}")
        return False

def view_tables(conn):
    """View all tables in the database"""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        print("\nTables in database:")
        for table in tables:
            print(table[0])
    except sqlite3.Error as e:
        print(f"An error occurred: {e}")

def setup_database():
    """Main function to setup the database"""
    conn = None
    try:
        conn = create_database_connection()
        if execute_sql_script(conn, 'ddl/all_component_reworked.sql'):
            print("Database setup completed successfully")
            view_tables(conn)
    except Exception as e:
        print(f"Setup failed: {e}")
    finally:
        if conn:
            conn.close()

if __name__ == '__main__':
    setup_database()