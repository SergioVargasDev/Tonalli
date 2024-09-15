import psycopg2
from psycopg2 import DatabaseError
from decouple import config

def get_connection():
    try:
        # Get connection details from environment variables
        connection = psycopg2.connect(
            host=config('PGSQL_HOST'),
            port=config('PGSQL_PORT'),
            user=config('PGSQL_USER'),
            password=config('PGSQL_PASSWORD'),
            database=config('PGSQL_DATABASE')
        )
        
        # Optionally set client encoding
        connection.set_client_encoding('UTF8')

        print("Database connection successful!")
        return connection
    except DatabaseError as ex:
        print(f"Database connection error: {ex}")
        raise
