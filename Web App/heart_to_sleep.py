import json
import random
from datetime import datetime, timedelta

# Load heart rate data from heart.json
with open('heart.json') as f:
    heart_data = json.load(f)

# Process heart rate data to generate sleep data
sleep_data = []
start_time = datetime.now().replace(hour=22, minute=0, second=0)  # Start sleep at 10 PM
total_sleep_hours = 8  # Total hours of sleep

# Create sleep segments based on a typical sleep cycle
sleep_states = ["Light", "Deep", "REM"]
sleep_segments = [
    {"sleep_state": "Light", "hours": random.uniform(2, 3)},  # 2-3 hours of Light sleep
    {"sleep_state": "Deep", "hours": random.uniform(1.5, 2.5)},  # 1.5-2.5 hours of Deep sleep
    {"sleep_state": "REM", "hours": random.uniform(1, 2)},  # 1-2 hours of REM sleep
    {"sleep_state": "Light", "hours": random.uniform(1.5, 2.5)}  # Remaining Light sleep
]

# Calculate total hours and adjust if necessary
total_hours = sum(segment["hours"] for segment in sleep_segments)
if total_hours < total_sleep_hours:
    # Adjust the last segment if needed
    sleep_segments[-1]["hours"] += (total_sleep_hours - total_hours)

# Generate sleep data entries based on segments
for segment in sleep_segments:
    hours = segment["hours"]
    for hour in range(int(hours)):
        sleep_data.append({
            "sleep_state": segment["sleep_state"],
            "hours": 1,
            "time": (start_time + timedelta(hours=hour)).strftime('%H:%M')
        })
    # Add remaining minutes (if any)
    remaining_minutes = int((hours - int(hours)) * 60)
    if remaining_minutes > 0:
        sleep_data.append({
            "sleep_state": segment["sleep_state"],
            "hours": remaining_minutes / 60,
            "time": (start_time + timedelta(hours=int(hours))).strftime('%H:%M')
        })
        start_time += timedelta(hours=1)

    # Update start_time for the next segment
    start_time += timedelta(hours=int(hours))

# Save the generated sleep data to sleep.json
with open('sleep.json', 'w') as f:
    json.dump(sleep_data, f, indent=4)

print("sleep.json has been created.")
