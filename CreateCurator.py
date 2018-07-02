# importing the requests library
import requests
import argparse
'''
    Usage:
        python MakeWorkout.py "Rich B." "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwij59KXl_rbAhXL6oMKHTmMAbsQjRx6BAgBEAU&url=http%3A%2F%2Fhdwpro.com%2Fcool-image-3.html&psig=AOvVaw0PSuOZBUbKfHLdpVDJydr0&ust=1530406650565088"

'''

parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group()

parser.add_argument("name", help="name")
parser.add_argument("image", help="image")
args = parser.parse_args()

CuratorIDEndpoint = "http://localhost:8080/api/curators"
PARAMS = {'name': args.name, 'image': args.image}
r = requests.post(url = CuratorIDEndpoint, data = PARAMS)
pastebin_url = r.text
print("The pastebin URL is:%s"%pastebin_url)
