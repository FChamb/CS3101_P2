import argparse
import mysql.connector


def get_connection():
    return mysql.connector.connect(
        host="fc84.teaching.cs.st-andrews.ac.uk",
        user="fc84",
        password="<PASSWORD>",
        database="fc84_P2"
    )


def schedule(loc):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM scheduleEDB WHERE orig = %s", (loc,))
    for row in cursor.fetchall():
        print(row)


def service(hc, dep):
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM serviceEDBDEE WHERE hc = %s AND dep = %s", (hc, dep))
    for row in cursor.fetchall():
        print(row)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--schedule", type=str, help="Print station schedule")
    parser.add_argument("--service", nargs="2", metavar=('hc', 'dep'), help="Service stops")
    args = parser.parse_args()

    if args.schedule:
        schedule(args.schedule)
    elif args.service:
        schedule(args.service)

