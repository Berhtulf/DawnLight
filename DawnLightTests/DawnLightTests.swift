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
    
    override func setUp() {
        super.setUp()
        homeModel = HomeViewModel()
    }

    override func tearDown() {
        super.tearDown()
        homeModel = nil
    }
    
    func test_scientific_format() {
        let number: Float = 12456762
        XCTAssertEqual(number.toScientific, "1,25e+7")
    }
    
    func test_weather_api() throws {
        try WeatherAPI().getWeather(lat: 10, lon: 10) { data in
            guard data != nil  else { return }
            XCTAssertTrue(data?.status == "OK")
        }
    }
    
    func test_timinterval_to_time() {
        let interval:TimeInterval = 126890
        let (h,m,s) = interval.toHoursMinutesSeconds
        XCTAssertTrue(h == 35)
        XCTAssertTrue(m == 14)
        XCTAssertTrue(s == 50)
    }
}
