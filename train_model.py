# train_model.py
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
import joblib

# Simulated data
n_days = 30
n_sample = 144
np.random.seed(42)

solar_output = np.random.uniform(0, 10, size=n_days * n_sample)
energy_consumed = np.random.uniform(0, 8, size=n_days * n_sample)
battery_charge = np.random.uniform(10, 100, size=n_days * n_sample)
energy_remaining = battery_charge + solar_output - energy_consumed
energy_will_last = (energy_remaining >= 20).astype(int)

# Create DataFrame
df = pd.DataFrame({
    "Solar_Output": solar_output,
    "Energy_Consumed": energy_consumed,
    "Battery_Charge": battery_charge,
    "Energy_Remaining": energy_remaining,
    "Energy_will_last": energy_will_last
})

# Train model
X = df[["Solar_Output", "Energy_Consumed", "Battery_Charge"]]
y = df["Energy_will_last"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model = LogisticRegression()
model.fit(X_train, y_train)

# Save the model
joblib.dump(model, 'energy_model.pkl')
print("Model saved as energy_model.pkl")
