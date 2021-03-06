//
//  MainViewModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
    init() {
        brightness = UIScreen.main.brightness
        load()
        if CLLocationManager.locationServicesEnabled() {
            print("Creating GPS manager")
            location = LocationManager(listener: self)
        }
    }
    deinit {
        save()
    }
    
    @Published var alarmRinging = false
    
    @Published private(set) var model = SettingsModel()
    @Published var alarmSet = false
    @Published var isShowingBlackScreen = false
    @Published var isLoading = false
    @Published var sunriseAsDate: Date?
    
    var alarmController = AlarmController()
    var buzzDate = Date()
    var backupBuzz: Date {
        get {
            model.backupBuzz ?? Date()
        }
        set {
            model.backupBuzz = newValue
            setNewBuzzDate()
        }
    }
    var volume: Float {
        get {
            model.volume
        }
        set {
            model.volume = newValue
        }
    }
    var usingGPS: Bool {
        get {
            model.usingGPS
        }
        set {
            model.usingGPS = newValue
            if newValue {
                if location?.locationStatus == .denied {
                    model.usingGPS = false
                    showDeniedWarning()
                    model.usingGPS = false
                    return
                }
                if location == nil {
                    location = LocationManager(listener: self)
                }
                setNewBuzzDate()
            }
        }
    }
    var snoozeInterval: Int {
        get {
            model.snoozeInterval
        }
        set {
            model.snoozeInterval = newValue
        }
    }
    var alarm: Alarm {
        get {
            model.alarm
        }
        set {
            model.alarm = newValue
            print(model.alarm)
        }
    }
    
    let weatherAPI = WeatherAPI()
    var location: LocationManager?
    var sunriseTime: String? {
        if let sunriseDate = sunriseAsDate {
            return DateFormatter.localizedString(from: sunriseDate, dateStyle: .none, timeStyle: .short)
        }
        return nil
    }
    var buzzTime: String {
        return DateFormatter.localizedString(from: buzzDate, dateStyle: .none, timeStyle: .short)
    }
    
    private func formatData(_ data: SunriseData){
        model.sunrise = data.results.sunrise
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        if let date = dateFormatter.date(from: data.results.sunrise) {
            sunriseAsDate = date
            buzzDate = min(backupBuzz, date)
        }
    }
    
    //MARK: - Intents
    @Published var isShowingLocationWarning = false
    func showDeniedWarning() {
        print("Showing GPS warning")
        isShowingLocationWarning = true
    }
    func scheduleAlarm() {
        if usingGPS{
            guard let sunrise = sunriseAsDate else { return }
            buzzDate = sunrise
        }
        updateBuzzTimes()
        if (usingGPS){
            buzzDate = min(buzzDate, backupBuzz)
        }
        scheduleAlarm(date: buzzDate)
    }
    
    func scheduleAlarm(date: Date) {
        UIApplication.shared.isIdleTimerDisabled = true
        isShowingBlackScreen = false
        refreshTimer?.invalidate()
        alarmController.createAVPlayer(sound: alarm.systemName)
        alarmSet = true
        startScreenTimer()
        print("Alarm set to \(buzzDate), volume: \(volume), alarm: \(alarm.systemName)")
        NotificationController.requestNotification(time: buzzDate.timeIntervalSinceNow,
                                                   title: "Time to shine",
                                                   subtitle: DateFormatter.localizedString(from: buzzDate, dateStyle: .none, timeStyle: .medium),
                                                   uuid: "alarmNotification")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + buzzDate.timeIntervalSinceNow){
            print("Alarm ringing")
            self.alarmController.play(volume: self.volume)
            self.hideBlackScreen()
            self.alarmSet = false
            self.alarmRinging = true
        }
    }
    func snoozeAlarm() {
        alarmController.cancelAlarm()
        buzzDate.addTimeInterval(TimeInterval(model.snoozeInterval * 5 * 60))
        scheduleAlarm(date: buzzDate)
    }
    func cancelAlarm() {
        alarmController.cancelAlarm()
        alarmSet = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private var refreshTimer: Timer?
    func startScreenTimer() {
        self.refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.refreshTimer = timer
            if (self.alarmSet) {
                self.showBlackScreen()
            }else{
                self.refreshTimer?.invalidate()
            }
        }
    }
    
    var brightness: CGFloat
    func showBlackScreen() {
        brightness = UIScreen.main.brightness
        isShowingBlackScreen = true
        refreshTimer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            UIScreen.main.brightness = CGFloat(0)
        }
    }
    func hideBlackScreen() {
        UIScreen.main.brightness = CGFloat(brightness)
        isShowingBlackScreen = false
    }
    func loadWeatherData() {
        if (sunriseAsDate == nil && isLoading == false) {
            sendAPIReguest()
        } else if let sunriseDate = sunriseAsDate {
            if sunriseDate.timeIntervalSinceNow < 0 {
                sendAPIReguest()
            }
        }
    }
    
    func sendAPIReguest() {
        isLoading = true
        if let latitude = self.location?.lastLocation?.coordinate.latitude, let longitude = self.location?.lastLocation?.coordinate.longitude {
            try? self.weatherAPI.getWeather(lat: latitude, lon: longitude) { data in
                guard let data = data else { return }
                self.formatData(data)
                self.isLoading = false
            }
        }
    }
    
    func updateBuzzTimes() {
        if backupBuzz.timeIntervalSinceNow < 0 {
            backupBuzz.addTimeInterval(86400)
        }
        if backupBuzz.timeIntervalSinceNow > 86400 {
            backupBuzz.addTimeInterval(-86400)
        }
        if buzzDate.timeIntervalSinceNow > 86400 {
            buzzDate.addTimeInterval(-86400)
        }
        if buzzDate.timeIntervalSinceNow < 0 {
            buzzDate.addTimeInterval(86400)
        }
    }
    func setNewBuzzDate() {
        buzzDate = sunriseAsDate ?? Date()
        updateBuzzTimes()
        buzzDate = min(buzzDate, backupBuzz)
    }
    
    func save() {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(model)
        
        UserDefaults.standard.setValue(data, forKey: "HomeModel")
        print("UserDefaults SAVED")
    }
    func load() {
        guard let data = UserDefaults.standard.data(forKey: "HomeModel") else {
            return
        }
        let decoder = JSONDecoder()
        let savedData = try? decoder.decode(SettingsModel.self, from: data)
        if let data = savedData {
            model = data
            print("UserDefaults LOADED")
        }
    }
}
