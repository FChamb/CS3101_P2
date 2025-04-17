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
    connection = get_connection()
    cursor = connection.cursor()
    try:
        cursor.execute("SELECT * FROM scheduleEDB WHERE orig = %s", (loc,))
        result = cursor.fetchall()
        for row in result:
            print(row)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        connection.close()


def service(hc, dep):
    connection = get_connection()
    cursor = connection.cursor()
    try:
        cursor.execute("SELECT * FROM serviceEDBDEE WHERE hc = %s AND dep = %s", (hc, dep))
        result = cursor.fetchall()
        for row in result:
            print(row)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        cursor.close()
        connection.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--schedule", type=str, help="Print station schedule")
    parser.add_argument("--service", nargs=2, metavar=('hc', 'dep'), help="Service stops")

    args = parser.parse_args()

    if args.schedule:
        schedule(args.schedule)
    elif args.service:
        service(args.service[0], args.service[1])

