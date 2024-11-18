import streamlit as st
import pandas as pd
import json
import plotly.express as px
from datetime import datetime

# Load heart rate data from JSON file
with open('heart.json') as f:
    data = json.load(f)

# Convert data into a DataFrame
df = pd.DataFrame(data)

# Convert the 'time' column to a datetime format, assuming date is today's date
df['timestamp'] = pd.to_datetime(df['time'], format='%H:%M').apply(lambda x: x.replace(year=datetime.now().year, month=datetime.now().month, day=datetime.now().day))

# Convert heartRate to numeric
df['heartRate'] = pd.to_numeric(df['heartRate'])

# Load steps data from JSON file
with open('steps.json') as f:
    steps_data = json.load(f)

# Convert steps data into a DataFrame
steps_df = pd.DataFrame(steps_data)
steps_df['timestamp'] = pd.to_datetime(steps_df['time'], format='%H:%M').apply(lambda x: x.replace(year=datetime.now().year, month=datetime.now().month, day=datetime.now().day))

# Load sleep data from JSON file
with open('sleep.json') as f:
    sleep_data = json.load(f)

# Convert sleep data into a DataFrame
sleep_df = pd.DataFrame(sleep_data)
sleep_df['timestamp'] = pd.to_datetime(sleep_df['time'], format='%H:%M').apply(lambda x: x.replace(year=datetime.now().year, month=datetime.now().month, day=datetime.now().day))

# Navigation Menu
menu = st.selectbox('Navigation', ['Heart Analysis', 'Steps Analysis', 'Sleep Analysis', 'Tips'])

# Adding some custom CSS for a more colorful UI
st.markdown("""
    <style>
    .main {
        background-color: #1c1c1c;  /* Dark Grey background */
    }
    .css-1aumxhk {
        background-color: #1c1c1c;  /* Dark Grey background */
    }
    h1 {
        color: #ffffff;  /* White text for headings */
    }
    h2, h3, h4 {
        color: #ffcc00;  /* Yellow for subheadings */
    }
    .css-18e3th9 {
        color: #e0e0e0;  /* Light Grey text for body */
    }
    </style>
    """, unsafe_allow_html=True)

# Heart Analysis Tab
if menu == 'Heart Analysis':
    st.title("Heart Rate Dashboard")
    st.markdown("### Track your heart health over time ❤️")

    # Plot heart rate over time
    fig = px.line(df, x='timestamp', y='heartRate', title='Heart Rate Over Time', labels={'timestamp': 'Time', 'heartRate': 'Heart Rate (BPM)'})
    st.plotly_chart(fig)

    # Heart Rate Summary
    avg_heart_rate = df['heartRate'].mean()
    min_heart_rate = df['heartRate'].min()
    max_heart_rate = df['heartRate'].max()

    st.markdown(f"**Average Heart Rate:** {avg_heart_rate:.2f} BPM")
    st.markdown(f"**Minimum Heart Rate:** {min_heart_rate} BPM")
    st.markdown(f"**Maximum Heart Rate:** {max_heart_rate} BPM")

    # Emoji-based summary
    if avg_heart_rate < 60:
        st.markdown("Your heart rate seems lower than average.")
        st.markdown(f'<p style="font-size: 80px; text-align: center;">😔</p>', unsafe_allow_html=True)
    elif 60 <= avg_heart_rate <= 100:
        st.markdown("Your heart rate is within a healthy range.")
        st.markdown(f'<p style="font-size: 80px; text-align: center;">😊</p>', unsafe_allow_html=True)
    else:
        st.markdown("Your heart rate is higher than normal.")
        st.markdown(f'<p style="font-size: 80px; text-align: center;">😔</p>', unsafe_allow_html=True)

    # Detailed Heart Analysis Report
    st.subheader("📝 Detailed Heart Rate Report")
    st.markdown(f"""
    - **Average Heart Rate:** {avg_heart_rate:.2f} BPM
    - **Minimum Heart Rate:** {min_heart_rate} BPM
    - **Maximum Heart Rate:** {max_heart_rate} BPM
    - **Observations:**
        - Your heart rate fluctuates throughout the day.
        - Maintaining a heart rate between 60 and 100 BPM is considered healthy.
    - **Recommendations:**
        - Engage in regular cardiovascular exercise, such as walking, jogging, or cycling.
        - Monitor for any irregular patterns and consult a doctor if necessary.
    """)

# Steps Analysis Tab
if menu == 'Steps Analysis':
    st.title("Steps Dashboard")
    st.markdown("### Monitor your physical activity 📊")
    total_steps = sum(entry["steps"] for entry in steps_data)
    # User inputs for weight and calories consumed
    weight = st.number_input("Enter your weight (in kg):", min_value=30.0, max_value=300.0, value=70.0)
    calories_consumed = st.number_input("Enter calories consumed today:", min_value=0, value=2000)
    
    # Calculate calories burned per step (average value)
    calories_per_step = 0.05  # Adjust based on personal metrics
    total_calories_burned = total_steps * calories_per_step

    # Calculate step goal based on calories
    calorie_goal = 500  # Example calorie goal for weight loss
    step_goal = calorie_goal / calories_per_step

    # Display results
    st.write(f"**Total Steps Today:** {total_steps}")
    st.write(f"**Total Calories Burned:** {total_calories_burned:.2f} kcal")
    st.write(f"**Step Goal to Burn {calorie_goal} Calories:** {int(step_goal)} steps")

    # Feedback based on goals
    if total_steps >= step_goal:
        st.markdown("😊 Great job! You've reached your step goal!")
    else:
        st.markdown("😞 Keep going! You're on your way to reach your step goal.")

    # Create a DataFrame for Plotly
    df_steps = pd.DataFrame(steps_data)

    # Plotting the step data using Plotly
    fig = px.line(df_steps, x='time', y='steps', markers=True, title='Steps Over Time')
    fig.update_layout(
        xaxis_title='Time',
        yaxis_title='Steps',
        title_x=0.5
    )
    st.plotly_chart(fig)

    # Detailed report
    st.subheader("Detailed Report")
    st.markdown(f"""
    - **Your Weight:** {weight} kg
    - **Calories Consumed Today:** {calories_consumed} kcal
    - **Calculated Step Goal:** {int(step_goal)} steps
    - **Total Steps Achieved:** {total_steps} steps
    - **Total Calories Burned:** {total_calories_burned:.2f} kcal

    **Observations:**
    - To achieve weight management or loss, it's essential to balance calories consumed with calories burned.
    - Aim to meet or exceed your daily step goal to enhance your overall health and fitness.

    **Recommendations:**
    - Try to incorporate walking into your daily routine, such as taking the stairs or walking during breaks.
    - Consider tracking your meals to better manage caloric intake.
    """)


# Sleep Analysis Tab
if menu == 'Sleep Analysis':
    st.title("Sleep Analysis Dashboard")
    st.markdown("### Analyze your sleep patterns 🛌")

    # Plot Sleep States over Time
    sleep_fig = px.bar(sleep_df, x='timestamp', y='sleep_state', title='Sleep States Over Time', labels={'timestamp': 'Time', 'sleep_state': 'Sleep State'})
    st.plotly_chart(sleep_fig)

    # Sleep Summary
    total_sleep_hours = sleep_df['hours'].sum()
    avg_sleep_hours = sleep_df['hours'].mean()
    rem_sleep_hours = sleep_df[sleep_df['sleep_state'] == 'REM']['hours'].sum()
    deep_sleep_hours = sleep_df[sleep_df['sleep_state'] == 'Deep']['hours'].sum()

    st.markdown(f"**Total Sleep Hours:** {total_sleep_hours} hours")
    st.markdown(f"**Average Sleep Hours Per Day:** {avg_sleep_hours:.2f} hours")
    st.markdown(f"**REM Sleep Hours:** {rem_sleep_hours} hours")
    st.markdown(f"**Deep Sleep Hours:** {deep_sleep_hours} hours")

    # Emoji-based summary
    if avg_sleep_hours >= 7 and deep_sleep_hours >= 1.5:
        st.markdown("Your sleep quality seems optimal.")
        st.markdown(f'<p style="font-size: 80px; text-align: center;">😊</p>', unsafe_allow_html=True)
    else:
        st.markdown("You may not be getting enough quality sleep.")
        st.markdown(f'<p style="font-size: 80px; text-align: center;">😔</p>', unsafe_allow_html=True)

    # Detailed Sleep Analysis Report
    st.subheader("📝 Detailed Sleep Report")
    st.markdown(f"""
    - **Total Sleep Hours:** {total_sleep_hours} hours
    - **Average Sleep Hours Per Day:** {avg_sleep_hours:.2f} hours
    - **REM Sleep Hours:** {rem_sleep_hours} hours
    - **Deep Sleep Hours:** {deep_sleep_hours} hours
    - **Observations:**
        - Aim for at least 7 hours of sleep each night for optimal health.
        - Ensure you have sufficient deep and REM sleep for recovery and cognitive function.
    - **Recommendations:**
        - Maintain a regular sleep schedule by going to bed and waking up at the same time each day.
        - Create a relaxing bedtime routine to signal your body it's time to sleep.
    """)

    # Tips Tab
if menu == 'Tips':
    st.title("Health and Wellness Tips")
    
    # Heart Health Tips
    st.subheader("❤️ Tips to Improve Heart Health")
    st.markdown("""
    - **Stay Active**: Engage in at least 30 minutes of physical activity most days of the week.
    - **Eat a Heart-Healthy Diet**: Focus on whole grains, fruits, vegetables, and lean proteins.
    - **Manage Stress**: Practice relaxation techniques such as deep breathing, meditation, or yoga.
    - **Get Enough Sleep**: Aim for 7-9 hours of quality sleep each night.
    """)
    
    st.markdown("""
    **Relevant Links:**
    - [Heart-Healthy Diet](https://www.heart.org/en/healthy-living/healthy-eating)
    - [Exercise for Heart Health](https://www.cdc.gov/physicalactivity/basics/pa-health/index.htm)
    """)

    # Sleep Health Tips
    st.subheader("🛌 Tips to Improve Sleep Quality")
    st.markdown("""
    - **Maintain a Consistent Sleep Schedule**: Go to bed and wake up at the same time every day.
    - **Create a Relaxing Bedtime Routine**: Avoid screens and try reading, listening to calm music, or taking a warm bath before bed.
    - **Optimize Your Sleep Environment**: Make your bedroom dark, quiet, and cool.
    - **Watch What You Eat and Drink**: Avoid large meals, caffeine, and alcohol close to bedtime.
    """)
    
    st.markdown("""
    **Relevant Links:**
    - [How to Improve Sleep Quality](https://www.sleepfoundation.org/how-sleep-works/how-to-sleep-better)
    - [The Importance of REM Sleep](https://www.healthline.com/health/rem-sleep)
    """)

    # Overall Wellness Tips
    st.subheader("💪 General Wellness Tips")
    st.markdown("""
    - **Stay Hydrated**: Drink plenty of water throughout the day.
    - **Eat Balanced Meals**: Ensure a good mix of macronutrients in your diet.
    - **Move Regularly**: Incorporate short, frequent movement breaks throughout your day.
    - **Practice Gratitude**: Maintain a positive outlook by focusing on things you’re thankful for.
    """)

# General Wellness Tips
st.sidebar.header("💪 General Wellness Tips")
st.sidebar.markdown("""
- **Stay Hydrated**: Drink plenty of water throughout the day.
- **Eat Balanced Meals**: Ensure a good mix of macronutrients in your diet.
- **Move Regularly**: Incorporate short, frequent movement breaks throughout your day.
- **Practice Gratitude**: Maintain a positive outlook by focusing on things you’re thankful for.
""")
