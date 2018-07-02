import requests
import argparse
import json


workout_name = raw_input('Please enter name for workout:\t')
workout_curator_id = raw_input('Please enter curator id for workout:\t')
workout_body_part = raw_input('Please enter body part for this workout:\t')


WorkoutEndpoint = "http://localhost:8080/api/workout"
PARAMS = {'name': workout_name, 'curatorID': workout_curator_id, 'bodyPart': workout_body_part}
r = requests.post(url = WorkoutEndpoint, data = PARAMS)
pastebin_url = r.text


number_of_supersets = int(raw_input('Please enter number of super-sets'))
for x in range(0, number_of_supersets):
    workout_id = json.loads(r.text)['id']
    superset_identifier_value = raw_input('Input Super Set Identifier!:')

    super_set_endpoint = "http://localhost:8080/api/superset"
    SUPER_SET_PARAMS = {'identifier': superset_identifier_value }

    super_set_req = requests.post(url = super_set_endpoint, data = SUPER_SET_PARAMS)
    superset_id = json.loads(super_set_req.text)['id']


    workout_superset_base_url = "http://localhost:8080/api/workout"
    workout_path = "/" + workout_id + "/"
    superset_path = "superset/" + superset_id

    workout_superset_endpoint = workout_superset_base_url + workout_path + superset_path
    workout_superset_request = requests.post(url = workout_superset_endpoint)

    number_of_sets_for_superset = int(raw_input('Please enter number of sets for this superset'))
    for x in range(0, number_of_sets_for_superset):
        WORKOUT_SET_ENDPOINT = "http://localhost:8080/api/sets/"

        name = raw_input('Please enter name for set... i.e.: Bench Press ')
        description = raw_input('Please enter set description for set... i.e.: 10, 10, 10, 10, 10 ')
        bodyPart = raw_input('Please enter set bodyPart for set... i.e.: Chest')

        SUPER_SET_PARAMS = {'name': name, 'description': description, 'bodyPart': bodyPart, 'superSetIdentification': superset_id}
        workout_set_request = requests.post(url = WORKOUT_SET_ENDPOINT, data = SUPER_SET_PARAMS)

        


    


