import requests
import json
import numpy as np
# Assuming you have an array of values
input_values = [45, 0, 1, 120, 200, 0, 1, 160, 0, 0.5, 1, 0, 2]
no_disease_example = np.array([35, 0, 0, 110, 180, 0, 0, 150, 0, 0.2, 1, 0, 2])


# Convert the list to a string with comma separation
input_string = ",".join(map(str, input_values))

# Create a dictionary with the 'user_input' key
data = {'user_input': input_string}

# Update the URL to match your Flask app endpoint
url = "http://localhost:5000"

# Send the POST request
resp = requests.post(url, data=data)

# Print the JSON response
print(resp.json())
