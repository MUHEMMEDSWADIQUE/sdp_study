from pyspark import pipelines as dp
from pyspark.sql.functions import col


# This file defines a sample transformation.222
# Edit the sample below or add new transformations
# using "+ Add" in the file browser.


@dp.table
def sample_trips_sdp_test():
    return spark.read.table("samples.nyctaxi.trips")
