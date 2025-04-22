# CS3101 Databases P2 - 220010065 #
### Introduction ###


### How to run Python Interface ###
1. Install MariaDB onto lab pc with:
```console
pip3 install mariadb==1.0.11
```
2. CD into current project directory and src:
3. Alter rtt.py which has hard coded values for accessing the database:
```console
nano rtt.py
```
3. Run the following commands depending on --schedule or --service:
```console
python3 rtt.py --schedule <loc>
```
```console
python3 rtt.py --service <hc> <loc>
```