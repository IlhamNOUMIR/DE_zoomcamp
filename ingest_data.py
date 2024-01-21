import pandas as pd
from sqlalchemy import create_engine, Table, Column, Integer, Float, Text, DateTime, MetaData
from time import time

# Définir le générateur une fois en dehors de la boucle
url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"
df_iter = pd.read_csv(url,  iterator=True, chunksize=100000)
df_schema = pd.read_csv(url, nrows=1)

# Créer le moteur SQLAlchemy pour PostgreSQL
engine = create_engine('postgresql://root:root@pg_database:5432/ny_taxi')

# Définir les types de données SQLAlchemy en fonction de votre DataFrame
column_types = {
    'VendorID': Integer,
    'tpep_pickup_datetime': DateTime,
    'tpep_dropoff_datetime': DateTime,
    'passenger_count': Integer,
    'trip_distance': Float,
    'RatecodeID': Integer,
    'store_and_fwd_flag': Text,
    'PULocationID': Integer,
    'DOLocationID': Integer,
    'payment_type': Integer,
    'fare_amount': Float,
    'extra': Float,
    'mta_tax': Float,
    'tip_amount': Float,
    'tolls_amount': Float,
    'improvement_surcharge': Float,
    'total_amount': Float,
    'congestion_surcharge': Float
}

# Créer un objet MetaData
metadata = MetaData()

# Créer la table avec les colonnes spécifiées
table = Table('yellow_taxi_data', metadata, *[
    Column(col, col_type) for col, col_type in column_types.items()
])

# Créer la table dans la base de données
metadata.create_all(engine)

# Assurez-vous d'avoir défini df_iter comme un générateur produisant des chunks du DataFrame
table_name = 'yellow_taxi_data'

while True:
    try:
        t_start = time()

        df = next(df_iter)

        if df.empty:
            # Condition de sortie si le chunk est vide
            print("No more data to insert.")
            break

        df['tpep_pickup_datetime'] = pd.to_datetime(df['tpep_pickup_datetime'])
        df['tpep_dropoff_datetime'] = pd.to_datetime(df['tpep_dropoff_datetime'])

        df.to_sql(name=table_name, con=engine, if_exists='append', index=False)

        t_end = time()

        print('Inserted another chunk, took %.3f seconds' % (t_end - t_start))

    except StopIteration as e:
        # Condition de sortie basée sur l'exception
        print("Finished ingesting data into the postgres database")
        break
