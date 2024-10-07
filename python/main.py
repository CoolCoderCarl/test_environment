from distutils.log import debug 
from fileinput import filename 
from flask import *  

import boto3
from botocore.exceptions import NoCredentialsError

bucket_name = 'bucket-patients-result-docs-1'
path_to_htmls = '/var/www/web/templates'

def upload_to_s3(file_name, bucket, object_name=None):
    if object_name is None:
        object_name = file_name

    s3_client = boto3.client('s3')

    try:
        s3_client.upload_file(file_name, bucket, object_name)
        print(Success)
    except FileNotFoundError:
        print('The file {file_name} was not found')
    except NoCredentialsError:
        print('Credentials not available')
    except Exception as e:
        print('An error occurred: {e}')


app = Flask(__name__, template_folder=path_to_htmls)
  
@app.route('/')
def main():
    return render_template('index.html')
  
@app.route('/success', methods = ['POST'])   
def success():   
    if request.method == 'POST':   
        f = request.files['file'] 
        f.save(f.filename)
        
        upload_to_s3(f.filename, bucket_name)
        return render_template('acknowledgement.html', name = f.filename)   


if __name__ == '__main__':   
    app.run(debug=True, port=80, host='0.0.0.0')
