from flask import Flask, jsonify, request
from flask_restful import Resource, Api
from gtts import gTTS
import eng_to_ipa as p


# creating the flask app
app = Flask(__name__)
# creating an API object
api = Api(app)

# making a class for a particular resource
# the get, post methods correspond to get and post requests
# they are automatically mapped by flask_restful.
# other methods include put, delete, etc.
class SpeechService(Resource):

	# corresponds to the GET request.
	# this function is called whenever there
	# is a GET request for this resource
	def get(self):

		return jsonify({'message': 'Response from speech service...'})

	# Corresponds to POST request
	def post(self):
		
		data = request.get_json()	 # status code
		return jsonify({'data': data}), 201


# another resource to get phonetics of the name
class Phonetics(Resource):

	def get(self, uid, name_to_phonetics):
		phonetics  = p.convert(name_to_phonetics)
		# Language we want to use for generating speech file
		language = 'en'
		mySpeech = gTTS(text=name_to_phonetics, lang=language, slow=False)
		ext= '.mp3'
		fileLocation= uid+'-'+name_to_phonetics+ext
		mySpeech.save(fileLocation) 
		return jsonify({'phonetics': phonetics, 'fileLocation':fileLocation})		


# adding the defined resources along with their corresponding urls
api.add_resource(SpeechService, '/')
api.add_resource(Phonetics, '/phonetics/<string:uid>/<string:name_to_phonetics>')


# driver function
if __name__ == '__main__':

	app.run(debug = True)
