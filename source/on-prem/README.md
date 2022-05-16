# pronounce
Hackathon 

# Install following software packages using pip

1) eng_to_ipa - used to generate phonetics for the given text
> pip install eng_to_ipa

2) gTTS (Google Text-to-Speech)is a Python library and CLI tool to interface with Google Translate text-to-speech API
> pip install gtts

3) Flask is a micro web application framework written used here to develop REST endpoints.
> pip install flask

4) Deployment - use below command to run the application
> flask run

# Rest API usage:
Below is the end point usage for getting phonetcis and creating the speech file. 
http://localhost:5000/phonetics/{empId}/{name_to_pronounce}

Example: 
http://localhost:5000/phonetics/u812/Paul John
Sample Response:
    {
        "fileLocation": "u812-Paul John.mp3",
        "phonetics": "pɔl ʤɑn"
    }

Note: Currently the audio file will generate in the location where the application is running. However we can specify a different location to generate the speech file and can update the file location in the response.
