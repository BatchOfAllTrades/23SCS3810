"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
Student(s): Matt Bacheldor
Description: A data load script for the IPPS database
"""

import psycopg2
import configparser as cp
import csv

config = cp.RawConfigParser()
config.read("ConfigFile.properties")
params = dict(config.items("db"))

conn = psycopg2.connect(**params)
if conn:
    print("Connection to Postgres database " + params["dbname"] + " was successful!")

    fileName = input("Enter path to file (including file name): ")
    with open(fileName, "r") as csvfile:
        reader = csv.reader(csvfile, delimiter=",")
        next(reader)
        for row in reader:
            Rndrng_Prvdr_CCN = row[0]
            Rndrng_Prvdr_Org_Name = "'" + row[1] + "'"
            Rndrng_Prvdr_St = "'" + row[2] + "'"
            Rndrng_Prvdr_City = "'" + row[3] + "'"
            Rndrng_Prvdr_State_Abrvtn = "'" + row[4] + "'"
            Rndrng_Prvdr_State_FIPS = row[5]
            Rndrng_Prvdr_Zip5 = row[6]
            Rndrng_Prvdr_RUCA = row[7]
            Rndrng_Prvdr_RUCA_Desc = "'" + row[8] + "'"
            DRG_Cd = row[9]
            DRG_Desc = "'" + row[10] + "'"
            Tot_Dschrgs = row[11]
            Avg_Submtd_Cvrd_Chrg = row[12]
            Avg_Tot_Pymt_Amt = row[13]
            Avg_Mdcr_Pymt_Amt = row[14]

            cur = conn.cursor()

            sql = "INSERT INTO RUCAs VALUES (%s, %s);"
            sql2 = "INSERT INTO providers VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
            sql3 = "INSERT INTO DRGs VALUES (%s, %s);"
            sql4 = "INSERT INTO ProviderCharges VALUES (%s, %s, %s, %s, %s, %s)"
            try:
                cur.execute(sql % (Rndrng_Prvdr_RUCA, Rndrng_Prvdr_RUCA_Desc))
                conn.commit()
            except:
                conn.rollback()

            try:
                cur.execute(
                    sql2
                    % (
                        Rndrng_Prvdr_CCN,
                        Rndrng_Prvdr_Org_Name,
                        Rndrng_Prvdr_St,
                        Rndrng_Prvdr_City,
                        Rndrng_Prvdr_State_Abrvtn,
                        Rndrng_Prvdr_State_FIPS,
                        Rndrng_Prvdr_Zip5,
                        Rndrng_Prvdr_RUCA,
                    )
                )
                conn.commit()
            except:
                conn.rollback()

            try:
                cur.execute(sql3 % (DRG_Cd, DRG_Desc))
                conn.commit()
            except:
                conn.rollback()

            try:
                cur.execute(
                    sql4
                    % (
                        Avg_Submtd_Cvrd_Chrg,
                        DRG_Cd,
                        Rndrng_Prvdr_CCN,
                        Avg_Tot_Pymt_Amt,
                        Avg_Mdcr_Pymt_Amt,
                        Tot_Dschrgs,
                    )
                )
                conn.commit()
            except:
                conn.rollback()

    print("Bye!")
    conn.close()

