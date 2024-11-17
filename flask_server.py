from flask import Flask, jsonify
import serial
import numpy as np
import joblib

# Initialize the Flask app
app = Flask(__name__)

# Load the trained machine learning model
model = joblib.load('energy_model.pkl')

# Configure Serial connection to Arduino
# Replace 'COM3' with your Arduino's port
arduino_port = 'COM4'
baud_rate = 9600
ser = serial.Serial(arduino_port, baud_rate, timeout=1)

@app.route('/data', methods=['GET'])
def get_data():
    """
    Fetch data from the Arduino, make predictions using the ML model,
    and return the processed data in JSON format.
    """
    try:
        # Read a line from the Serial connection
        line = ser.readline().decode('utf-8').strip()
        values = line.split(',')

        # Ensure we have all the expected values from the Arduino
        if len(values) == 4:
            # Parse the data into meaningful variables
            temperature = float(values[0])
            light_intensity = float(values[1])
            potentiometer_voltage = float(values[2])
            solar_panel_voltage = float(values[3])

            # Determine power mode based on light intensity
            power_mode = "Power Saving" if light_intensity < 300 else "Normal"

            # Prepare input data for prediction
            input_data = np.array([temperature, light_intensity, potentiometer_voltage, solar_panel_voltage]).reshape(1, -1)
            energy_will_last = model.predict(input_data)[0]

            # Prepare response data
            data = {
                'temperature': temperature,
                'light_intensity': light_intensity,
                'potentiometer_voltage': potentiometer_voltage,
                'solar_panel_voltage': solar_panel_voltage,
                'power_mode': power_mode,
                'prediction': int(energy_will_last)
            }
            return jsonify(data)

        else:
            return jsonify({'error': 'Incomplete data from Arduino'}), 400

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    try:
        print(f"Connecting to Arduino on {arduino_port}...")
        app.run(debug=True)
    except serial.SerialException:
        print("Error: Unable to connect to Arduino. Check the Serial port.")
