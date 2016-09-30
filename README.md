# TIP
A Portable Real Time ECG Device for Arrhythmia Detection Using Rasp-berry Pi

#Inspiration
Arrhythmia is an underlying cardiac condition that goes undetected in the earlier stages but later manifests itself as sudden cardiac arrest. This is especially observed in the elderly population, smokers and people having a family history of cardiac illness. The cost of diagnostics and the risk of delaying treatment inspired us As a result portable and sensitive ECG devices were the need of the hour to detect arrhythmia at an earlier stage when the prognosis of the disease is better.

#What it does
The device provides the user with a highly accurate _ real time _ ECG data. This data is further analyzed by scripts running on RasPi to detect underlying arrhythmia conditions. The real time ECG data is also simultaneously plotted on a android device connected to the RasPi WiFi access point. The Android app displays ECG and R-R peaks throughout the session. As the device is lightweight and portable, the entire session can be recorded during day to day activities. Upon completion of the session, a summary page giving details of the run will be displayed showing if any arrhythmia was detected or whether the heart rate was abnormally high or low during the session.

#How we built it
We built the initial hardware using 3- ECG patches (electrodes) connected to an AD8232 heart rate monitor. The analog signals from the Heart rate monitor are converted to digital signals and sent to RasPi. The RasPi is configured to act like a WiFi access point. Once the signals are received by the Raspberry Pi they are analyzed and transmitted through WiFi to the user's android device. The Android app has separate Accounts that are personalized based on the the users medical history, health habits, age and gender. This allows us to analyze heart rate effectively by incorporating these parameters into our real time data. When the user ends the session through the app, a summary of the session log is shown which contains details about whether any abnormalities were encountered during the session

#Challenges we ran into
The first major challenge was to set up the electrodes to get accurate ECG data. We achieved this by using a 3-lead ECG electrodes, all placed around the chest, instead of the usual 12-lead ECG, thus simplifying and improving user interface without compromising on accuracy. The second challenge was to configure RasPi3 as a WiFi hotspot so as to save precious battery on the mobile device while the app is active. Another challenge was to optimize the rate of data transfer in a D2D model between RasPi and the Android device. this had to be slow enough to plot and fast enough to not lag at Real Time.

#Accomplishments that we're proud of
We have created a portable device and a personalized android app that can be used a cheap diagnostic tool for cardiac health monitoring. Moreover, it emphasizes on arrhythmia detection which is often ignored in a simple ECG diagnostic tool. As every individual has a different hereditary condition and different dietary and physical routines we have incorporated those into our app for a more holistic and accurate ECG representation.

#What we learned
This was the first time we were building a project using Raspberry Pi and making an Android app. We learnt the specific of D2D communication along the way and also real time data sensing using sensors. We also learnt a lot about setting wireless communication between devices and data transfer and visualization.

#What's next for Customised app for ECG/Arrhythmia tracking using RasPi
We are also looking to incorporate existing healthcare systems like EPIC to our app that will enable the ECG log generated to be viewed by several clinicians and medics around the world or look to store patient information on cloud based servers for easy retrieval.
Built With

    raspberry-pi
    python
    android-studio
    heartrate-monitor-(ad8232)
    adc-mcp3008


