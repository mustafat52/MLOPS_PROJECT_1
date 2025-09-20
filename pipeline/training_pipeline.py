from src.data_ingestion import DatIngestion
from src.data_preprocessing import DataProcessor
from src.model_training import ModelTraining
from utils.common_func import read_yaml
from config.path_config import *



if __name__ == "__main__":

    #Data Ingestion
    data_ingestion  = DatIngestion(read_yaml(CONFIG_PATH))
    data_ingestion.run()

    #Data PreProcessing
    processor = DataProcessor(TRAIN_FILE_PATH, TEST_FILE_PATH, PROCESSED_DIR, CONFIG_PATH)
    processor.process()


    #Model Training
    trainer = ModelTraining(PROCESSED_TRAIN_DATA_PATH, PROCESSED_TEST_DATA_PATH, MODEL_OUTPUT_PATH)
    trainer.run()

