//
//  DawnLightTests.swift
//  DawnLightTests
//
//  Created by Martin Václavík on 16.02.2021.
//

@testable import DawnLight
import XCTest
import MediaPlayer

class DawnLightTests: XCTestCase {
    var homeModel: HomeViewModel!
    var currentTime: Date!
    
    override func setUp() {
        super.setUp()
        homeModel = HomeViewModel()
        currentTime = Date()
    }

    override func tearDown() {
        super.tearDown()
        homeModel = nil
        currentTime = nil
    }
    
    func test_timinterval_to_time() {
        let interval:TimeInterval = 126890
        let (h,m,s) = interval.toHoursMinutesSeconds
        XCTAssertTrue(h == 35)
        XCTAssertTrue(m == 14)
        XCTAssertTrue(s == 50)
    }
    func test_saved_data_loading(){
        homeModel.load()
        XCTAssertNotNil(homeModel.model)
    }
    
    func test_scheduleAlarmWithBackup() {
        homeModel.usingGPS = true
        
        homeModel.buzzDate = Date(timeInterval: 3600, since: currentTime)
        homeModel.backupBuzz = Date(timeInterval: 2000, since: currentTime)
        homeModel.scheduleAlarm()
        XCTAssertEqual(homeModel.buzzDate, Date(timeInterval: 2000, since: currentTime))
    }
    
    func test_scheduleAlarmWithBackupNoGPS() {
        homeModel.usingGPS = false
        
        homeModel.buzzDate = Date(timeInterval: 1800, since: currentTime)
        homeModel.backupBuzz = Date(timeInterval: 300, since: currentTime)
        homeModel.scheduleAlarm()
        
        XCTAssertEqual(homeModel.buzzDate, Date(timeInterval: 1800, since: currentTime))
    }
    
    func test_snoozeAlarm() {
        homeModel.usingGPS = false
        homeModel.buzzDate = currentTime.addingTimeInterval(600)
        
        homeModel.scheduleAlarm()
        homeModel.snoozeAlarm(by: 3600)
        
        XCTAssertEqual(homeModel.buzzDate, currentTime.addingTimeInterval(4200))
    }
}
