# CS3101 Databases P2 - 220010065 #
### Introduction ###
This project extends a relational railway database using 
MariaDB, SQL views, triggers, and stored procedures. It 
also includes a Python command-line interface (`rtt.py`) 
to query the system.

---

### Setup Instructions ###

#### 1. Load the Database ####

SSH into the School teaching server, load MariaDB and create
a new database and then run:
```bash
use <database_name>
source <CS3101_P2_dump.sql>
```

#### 2. Install MariaDB onto lab pc with: ####
```bash
pip3 install mariadb==1.0.11
```

#### 3. Update MariaDB credentials in rtt.py (look for the comment) ####

#### 4. Use the following commands to run command line interface: ####
```bash
python3 rtt.py --schedule <loc>
```
```bash
python3 rtt.py --service <hc> <loc>
```