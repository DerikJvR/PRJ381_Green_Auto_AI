from flask import Flask, jsonify
import random
import numpy as np
import joblib

app = Flask(__name__)

# Load the pre-trained model
model = joblib.load('energy_model.pkl')

@app.route('/data', methods=['GET'])
def get_data():
    temperature = round(random.uniform(0, 30), 2)
    light_intensity = random.randint(100, 1000)
    
    # Determine power mode based on light intensity
    power_mode = "Power Saving" if light_intensity < 300 else "Normal"
    
    # Use the model to predict if energy will last
    input_data = np.array([temperature, light_intensity, random.uniform(10, 100)]).reshape(1, -1)
    energy_will_last = model.predict(input_data)[0]
    
    data = {
        'temperature': temperature,
        'light_intensity': light_intensity,
        'power_mode': power_mode,
        'prediction': int(energy_will_last)
    }
    
    return jsonify(data)

if __name__ == '__main__':
    app.run(port=5000, debug=True)
