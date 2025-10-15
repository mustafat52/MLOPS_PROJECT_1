import traceback
import sys

class CustomException(Exception):

    # Changed: error_details argument now defaults to None and is checked below.
    def __init__(self, error_message, error_details=None):
        super().__init__(error_message)
        # Pass the current exception info (sys.exc_info()) to get the traceback
        self.error_messgae = self.get_detailed_error_message(error_message, error_details)

    @staticmethod
    def get_detailed_error_message(error_message, error_details:sys):
      
        if error_details:
             exc_tb = error_details.__traceback__
        else:
             _, _, exc_tb = sys.exc_info()

        # Fallback in case traceback info is unavailable
        if exc_tb is None:
             return f"Error: {error_message}"

        file_name = exc_tb.tb_frame.f_code.co_filename
        line_number = exc_tb.tb_lineno
        
        # Enhanced error message to include the file and line number where the error was raised/handled
        return f"Error occurred in file: [{file_name}], line: [{line_number}], Python error message: [{error_message}]"
    
    def __str__(self):
        return self.error_messgae
