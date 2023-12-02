from flask import Flask, request, jsonify
import numpy as np
from flask_cors import CORS
import joblib

app = Flask(__name__)
CORS(app)
# Load the best model and scaler
best_model = joblib.load('best_model.joblib')

def preprocess_input(user_input):
    user_input = np.array(user_input).reshape(1, -1)
    return user_input

def predict_heart_disease(user_input_scaled):
    prediction = best_model.predict(user_input_scaled)
    return prediction[0]

def interpret_prediction(prediction):
    if prediction == 1:
        return "Warning! You have chances of getting a heart disease!"
    else:
        return "You are healthy and are less likely to get a heart disease!"

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        user_input = request.form.get('user_input')  # assuming you send user input as a string
        if user_input is None or user_input == "":
            return jsonify({"error": "no user input"})

        try:
            # Convert user input to a list of floats
            user_input = [float(value) for value in user_input.split(",")]

            # Preprocess input
            user_input_scaled = preprocess_input(user_input)

            # Make predictions
            prediction = predict_heart_disease(user_input_scaled)

            # Interpret predictions
            result = {"prediction": interpret_prediction(prediction)}
            return jsonify(result)

        except Exception as e:
            return jsonify({"error": "invalid input"})

    return "OK"

if __name__ == "__main__":
    app.run(debug=True)
