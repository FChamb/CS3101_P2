import argparse
import mariadb
import sys


def get_connection():
    try:
        # THIS NEEDS TO BE ALTERED TO THE USER'S MARIADB CONNECTION!!
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
        cursor.execute("SELECT hc, dep, pl, dest, len, toc"
                       "FROM scheduleEDB"
                       "WHERE dest IS NOT NULL AND EXISTS (SELECT 1 FROM route WHERE orig = %s)", (loc,))
        rows = cursor.fetchall()
        if not rows:
            print(f"No services found for location '{loc}'")
            return
        print(f"Schedule for {loc}")
        for hc, dep, pl, dest, length, toc in rows:
            print(f" - {hc} departs at {dep:04d} from platform {pl}, "
                  f"destination: {dest}, coaches: {length}, operator: {toc}")
    except Exception as e:
        print(f"Query Error: {e}")
    finally:
        cursor.close()
        conn.close()


def service(hc, dep):
    conn = get_connection()
    cursor = conn.cursor()
    try:
        hour = int(dep[:2])
        minute = int(dep[2:])
        cursor.execute("SELECT loc, stn, pl, arr, dep"
                       "FROM serviceEDBDEE"
                       "WHERE hc = %s "
                       "AND EXISTS (SELECT 1 FROM service WHERE hc = %s AND dh = %s AND dm = %s) "
                       "ORDER BY arr", (hc, hc, hour, minute))
        rows = cursor.fetchall()
        if not rows:
            print(f"No stops found for service {hc} at {dep}")
            return
        print(f"Stops for service {hc} at {dep}")
        for loc, stn, pl, arr, dep in rows:
            print(f" - {loc} ({stn or '---'}) → Arr: {arr:04d if arr else '----'}, "
                  f"Dep: {dep:04d if dep else '----'}, Platform: {pl or '--'}")
    except Exception as e:
        print(f"Query Error: {e}")
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Railway timetable tool (RTT)")
    parser.add_argument("--schedule", metavar='loc', help="Show schedule for a location (e.g., EDB)")
    parser.add_argument("--service", nargs=2, metavar=('hc', 'dep'), help="Show stops for a service (e.g., 1L27 1859)")

    args = parser.parse_args()

    if args.schedule:
        schedule(args.schedule.upper())
    elif args.service:
        service(args.service[0].upper(), args.service[1])
    else:
        parser.print_help()
