import argparse
import mariadb
import sys


def get_connection():
    try:
        connection = mariadb.connect(
            host="fc84.teaching.cs.st-andrews.ac.uk",
            user="fc84",
            password="4E6QZk.S42F3fp",
            database="fc84_P2"
        )
        return connection
    except mariadb.Error as e:
        print(f"Error connecting to MariaDB database: {e}")
        sys.exit(1)


def schedule(loc):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT * FROM scheduleEDB")
        for row in cursor.fetchall():
            if row[0] == loc:
                print(row)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        conn.close()


def service(hc, dep):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT * FROM serviceEDBDEE")
        for row in cursor.fetchall():
            print(row)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--schedule", type=str, help="Print station schedule")
    parser.add_argument("--service", nargs=2, metavar=('hc', 'dep'), help="Service stops")

    args = parser.parse_args()

    if args.schedule:
        schedule(args.schedule)
    elif args.service:
        service(args.service[0], args.service[1])

