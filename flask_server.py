from flask import Flask, jsonify
import pandas as pd
from flask import Flask, jsonify
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
import joblib
import random

app = Flask(__name__)

# Load the pre-trained model
model = joblib.load('energy_model.pkl')

@app.route('/data', methods=['GET'])
def get_data():
    temperature = round(random.uniform(0, 30), 2)
    light_intensity = random.randint(100, 1000)
    
    # Determine power mode based on light intensity
    if light_intensity < 300:
        power_mode = "Power Saving"
    else:
        power_mode = "Normal"
    
    # Predict whether energy will last based on model inputs
    input_data = np.array([random.uniform(0, 10), random.uniform(0, 8), random.uniform(10, 100)]).reshape(1, -1)
    energy_will_last = model.predict(input_data)[0]
    
    data = {
        'temperature': temperature,
        'light_intensity': light_intensity,
        'power_mode': power_mode,
        'prediction': int(energy_will_last)
    }
    
    return jsonify(data)

if __name__ == '__main__':
    app.run(port=5000)
