import os
import pandas as pd
from google.cloud import storage
from sklearn.model_selection import train_test_split
from src.logger import get_logger
from src.custome_exception import CustomException
from config.path_config import *
from utils.common_func import read_yaml



logger = get_logger(__name__)



class DatIngestion:
    def __init__(self, config):
        self.config = config['data_ingestion']
        self.bucket_name = self.config['bucket_name']
        self.file_name = self.config['bucket_file_name']   # FIXED
        self.train_test_ratio = self.config['train_ratio']

        os.makedirs(RAW_DIR, exist_ok=True)
        logger.info(f"Data ingestion started with {self.bucket_name} and file is {self.file_name}")

    def download_csv_from_gcp(self):
        try:
            client = storage.Client()
            bucket = client.bucket(self.bucket_name)
            blob = bucket.blob(self.file_name)   # FIXED

            blob.download_to_filename(RAW_FILE_FATH)
            logger.info(f"Csv file is successfully downloaded to {RAW_FILE_FATH}")

        except Exception as e:
            logger.error("Error while downloading the csv file")
            raise CustomException(f"Failed to download csv file: {str(e)}")   # FIXED


    def split_data(self):
        try:
            logger.info("Starting the splitting process") 
            data = pd.read_csv(RAW_FILE_FATH)

            train_data, test_data = train_test_split(data, test_size=1-self.train_test_ratio)

            train_data.to_csv(TRAIN_FILE_PATH)
            test_data.to_csv(TEST_FILE_PATH)

            logger.info(f"Train data saved to {TRAIN_FILE_PATH}")
            logger.info(f"Test data saved to {TEST_FILE_PATH}")

        except Exception as e:
            logger.info("error raise while splitting the data")
            raise CustomException("Failed to split the data into training and testing sets",e)
        

    def run(self):
        try:
            logger.info("Starting data ingestion process")

            self.download_csv_from_gcp()
            self.split_data()

            logger.info("Data ingestion completed sucessfully")

        except Exception as ce:
            logger.error(f"CustomException : {str(ce)}")    

        finally:
            logger.info("Data ingestion COMPLETED")




if __name__ == "__main__":
    data_ingestion  = DatIngestion(read_yaml(CONFIG_PATH))
    data_ingestion.run()
