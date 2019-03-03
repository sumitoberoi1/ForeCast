About the App (ForeCast)

Forecast using open weather API to get the weather forecast for today.
App asks for location permission at the starting then reverse geocoding to get the proper location with Latitude and Longitude data.

To optimize battery usage I am just asking for the location the first time. But if there is a significant change in user location from last time it will automatically get the new location and perform current weather and forecast query. I am using CLLocation methods for this

These latitude and longitude data is used to query open weather API for current weather condition.
api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}

On successfully getting the data I am using city id to query forecast data
api.openweathermap.org/data/2.5/forecast?id={city ID}

This gives data for five days in the separation of three hours. It results in 40 weather data. 
For getting data for the next 24 hours I filter the data depending on the timestamp. These 8 data points are plotted in graph wrt to their time

I am also showing data such as Humidity, Pressure, Max-Min temperature, Visibility, windspeed cloudiness, sunrise, and sunset time

I wasn’t able to work on push notification part as I was thinking of building express server which will subscribe to alerts on this API http://api.openweathermap.org/data/3.0/triggers and using https://www.npmjs.com/package/apn. I will be able to push notification from my server to the device. But I didn’t have paid developer account so I was not able to work on that part

For testing 
1. Clone the project
2. Open Forecast.xcworkspace
3. Add your API key in Constants. Swift file Line 13
4. If you are not able to compile the project run ‘pod install’ from the terminal 
5. For best result please test app on an actual device
6. For testing on the device. Use these techniques: https://www.twilio.com/blog/2018/07/how-to-test-your-ios-application-on-a-real-device.html
7. If you are using Simulator to test the app. For faking location use this: https://willowtreeapps.com/ideas/simulating-location-in-ios
8. App won't show any data if you don't authorize for location


To improve upon the app following things can be done. I wasn’t able to do that because of lack of time:

1. Better Error Handling and Failure cases
2. Not pushing pods directory to GitHub
3. Better handling of string literal
4. Better UI
5. Better UI when the user doesn’t authorize location
6. Improving Location Manage
7. Storing previously used location and data wrt it in CoreData or realm
8. Push Notifications using express servers
9. Unit Testing app
10. Code Modularity and better use of design patterns
11. Making request again on failure
12. Proper configuring String literals and other constants file
