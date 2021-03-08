//
//  MainViewModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation
import Combine

class HomeViewModel: ObservableObject {
    @Published private(set) var model = SettingsModel()
    @Published private(set) var screenHider = ScreenHider()
    var screenHiderCancellable: AnyCancellable? = nil
    
    init() {
        let currentTime = Date()
        buzzDate = currentTime
        backupBuzz = currentTime
        
        load()
        if CLLocationManager.locationServicesEnabled() {
            location = LocationManager(listener: self)
        }
            screenHiderCancellable = screenHider.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    deinit {
        save()
    }
    
    @Published var alarmRinging = false
    @Published var alarmSet = false
    @Published var isLoading = false
    @Published var sunriseAsDate: Date?
    @Published var isShowingLocationWarning = false
    
    var alarmController = AlarmController()
    @Published var buzzDate: Date
    var backupBuzz: Date {
        get {
            model.backupBuzz
        }
        set {
            model.backupBuzz = newValue
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
    
    //MARK: - Private functions
    private func showDeniedWarning() {
        isShowingLocationWarning = true
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
    private func sendAPIReguest() {
        isLoading = true
        if let latitude = self.location?.lastLocation?.coordinate.latitude, let longitude = self.location?.lastLocation?.coordinate.longitude {
            try? self.weatherAPI.getWeather(lat: latitude, lon: longitude) { data in
                guard let data = data else { return }
                self.formatData(data)
                self.isLoading = false
            }
        }
    }
    private func correctBuzzTimes() {
        while buzzDate.timeIntervalSinceNow > 86400 {
            buzzDate.addTimeInterval(-86400)
        }
        while buzzDate.timeIntervalSinceNow < 0 {
            buzzDate.addTimeInterval(86400)
        }
        
        while backupBuzz.timeIntervalSinceNow < 0 {
            backupBuzz.addTimeInterval(86400)
        }
        while backupBuzz.timeIntervalSinceNow > 86400 {
            backupBuzz.addTimeInterval(-86400)
        }
    }
    
    //MARK: - Intents
    func checkLocationPermissions() {
        if location?.locationStatus == .denied {
            showDeniedWarning()
            model.usingGPS = false
            return
        }
        if location == nil {
            location = LocationManager(listener: self)
        }
    }
    
    func calculateBestTime() {
        guard !alarmRinging else { return }
        correctBuzzTimes()
        if usingGPS  {
            guard let sunrise = sunriseAsDate else {
                buzzDate = min(buzzDate, backupBuzz)
                return
            }
            buzzDate = min(sunrise, backupBuzz)
        }
    }
    func scheduleAlarm() {
        calculateBestTime()
        scheduleAlarm(date: buzzDate)
    }
    
    /// Schedules alarm to provided date
    /// - Parameter date: Alarm date
    func scheduleAlarm(date: Date) {
        UIApplication.shared.isIdleTimerDisabled = true
        alarmController.createAVPlayer(sound: alarm.systemName)
        alarmSet = true
        self.screenHider.startScreenTimer()
        
        print("Alarm set to \(buzzDate), alarm: \(alarm.systemName), volume: \(volume)")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + date.timeIntervalSinceNow){
            self.alarmController.play(volume: self.volume)
            self.screenHider.hideBlackScreen()
            self.alarmSet = false
            self.alarmRinging = true
        }
    }
    
    func snoozeAlarm(by snoozeInterval: TimeInterval) {
        alarmController.cancelAlarm()
        buzzDate.addTimeInterval(snoozeInterval)
        scheduleAlarm(date: buzzDate)
    }
    func cancelAlarm() {
        alarmController.cancelAlarm()
        screenHider.hideBlackScreen()
        alarmSet = false
        UIApplication.shared.isIdleTimerDisabled = false
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
    
    //MARK: - System functions
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
