#!/bin/bash

pip3.7 install boto3
pip3.7 install flask


# Create directories
mkdir -p /var/www/web/templates
mkdir -p /opt/local/bin
mkdir -p /etc/systemd/system


# main.py
echo "
from distutils.log import debug 
from fileinput import filename 
from flask import *  

import boto3
from botocore.exceptions import NoCredentialsError

bucket_name = 'bucket-results-doc-1'
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
" >> /opt/local/bin/main.py



# index.html
echo "
<html> 
<head> 
        <title>upload the file : GFG</title> 
</head> 
<body> 
        <form action = "/success" method = "post" enctype="multipart/form-data"> 
                <input type="file" name="file" /> 
                <input type = "submit" value="Upload"> 
        </form> 
</body> 
</html>
" >> /var/www/web/templates/index.html

# Acknowledgement.html
echo "
<html> 
<head> 
        <title>success</title> 
</head> 
<body> 
        <p>File uploaded successfully</p> 
        <p>File Name: {{name}}</p> 
</body> 
</html>
" >> /var/www/web/templates/acknowledgement.html


echo "
[Unit]
Description=Web Python App
After=network.target

[Service]
#User=yourusername
#Group=yourgroup
WorkingDirectory=/opt/local/bin
ExecStart=/bin/python3.7 /opt/local/bin/main.py
Restart=always
Environment=FLASK_ENV=dev

[Install]
WantedBy=multi-user.target
" >> /etc/systemd/system/web.service

# Manage system daemon
systemctl daemon-reload
systemctl enable --now web.service
