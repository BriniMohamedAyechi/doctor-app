import numpy as np
from sklearn.preprocessing import MinMaxScaler
import joblib

# Load the saved best model
best_model = joblib.load('heart_classifier.h5')  # Update with the correct model file name

# Sample input data for prediction (you can replace this with your actual input)
new_data = np.array([63, 1, 3, 145, 233, 1, 0, 150, 0, 2.3, 0, 0, 1]).reshape(1, -1)
no_disease_example = np.array([35, 0, 0, 110, 180, 0, 0, 170, 0, 0.2, 1, 0, 2]).reshape(1, -1)


# MinMax scaling for input features (assuming 'scaler' is the MinMaxScaler used during training)

# Make predictions using the loaded model
prediction = best_model.predict(no_disease_example)

# Display the prediction result
if prediction[0] == 0:
    print("You are healthy and are less likely to get a heart disease!")
else:
    print("Warning! You have chances of getting a heart disease!")
    print(prediction)
