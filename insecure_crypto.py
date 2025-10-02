import hashlib
import pickle
import os

# Insecure hash functions
def hash_password(password):
    # CKV_INSECURE_HASHES: Using weak MD5 hash
    return hashlib.md5(password.encode()).hexdigest()

def hash_data(data):
    # CKV_INSECURE_HASHES: Using weak SHA1 hash
    return hashlib.sha1(data.encode()).hexdigest()

# Insecure deserialization
def load_user_data(data):
    # CKV_PICKLE: Using pickle for deserialization (arbitrary code execution risk)
    return pickle.loads(data)

# Hardcoded credentials
def connect_to_database():
    # CKV_SECRET: Hardcoded password
    password = "admin123"
    username = "root"
    host = "localhost"

    connection_string = f"postgresql://{username}:{password}@{host}/mydb"
    return connection_string

# Insecure random number generation
def generate_token():
    # CKV_INSECURE_RANDOM: Using weak random for security-sensitive operation
    import random
    return random.randint(100000, 999999)

# SQL Injection vulnerability
def get_user(user_id):
    # CKV_SQL_INJECTION: String concatenation in SQL query
    query = f"SELECT * FROM users WHERE id = {user_id}"
    return query

# Command injection vulnerability
def execute_command(filename):
    # CKV_COMMAND_INJECTION: Unsanitized input in shell command
    os.system(f"cat {filename}")
