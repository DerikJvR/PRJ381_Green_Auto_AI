from flask import Flask, jsonify
import random
import numpy as np
import joblib

app = Flask(__name__)

model = joblib.load('energy_model.pkl')

@app.route('/data', methods=['GET'])
def get_data():
    temperature = round(random.uniform(0, 30), 2)
    light_intensity = random.randint(100, 1000)
    potentiometer_voltage = round(random.uniform(0.5, 5.0), 2)
    solar_panel_voltage = round(random.uniform(0, 2.5), 2)
    power_mode = "Power Saving" if light_intensity < 300 else "Normal"
    input_data = np.array([temperature, light_intensity, potentiometer_voltage, solar_panel_voltage]).reshape(1, -1)
    energy_will_last = model.predict(input_data)[0]

    data = {
        'temperature': temperature,
        'light_intensity': light_intensity,
        'potentiometer_voltage': potentiometer_voltage,
        'solar_panel_voltage': solar_panel_voltage,
        'power_mode': power_mode,
        'prediction': int(energy_will_last)
    }

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True)
