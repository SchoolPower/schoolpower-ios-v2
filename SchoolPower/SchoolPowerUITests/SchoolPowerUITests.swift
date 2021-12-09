//
//  SchoolPowerUITests.swift
//  SchoolPowerUITests
//
//  Created by Carbonyl on 2021-11-01.
//

import XCTest

class SchoolPowerUITests: XCTestCase {
    
    // use this for macOS screenshots
    let entireScreen = true
    
    var app : XCUIApplication!
    
    var screenshotIndex: Int = 0

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
//        app.launchEnvironment = ["TZ": "Asia/Shanghai"]

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        logout()
    }
    
    func testGatherScreenshots() throws {
        app.launch()
        
        logout()
        wait(1)
        
        login()
        ifIsIPhone { screenshot("courses") }
        
        goToCourse("Biology 12")
        wait(1)
        screenshot("courseDetail")
        ifIsIPhone { goBack() }
        
        goToTab(1)
        ifIsIPhone { screenshot("attendance") }
        
        ifIsIPad {
            goToAttendance("Excused Absence")
            screenshot("attendanceDetail")
        }
        
        goToTab(2)
        wait(2)
        screenshot("schedule")
        
        goToTab(3)
        
        tapButton("gpa")
        wait(1)
        screenshot("gpa")
        ifIsIPhone { goBack() }
        
        tapButton("radarChart")
        wait(1)
        screenshot("radarChart")
    }
    
    private func ifIsIPhone (_ code: () -> Void) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            code()
        }
    }
    
    private func ifIsIPad (_ code: () -> Void) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            code()
        }
    }
    
    private func goToTab(_ index: Int) {
        app.tabBars.element.buttons.element(boundBy: index).tap()
    }
    
    private func goBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    private func goToCourse(_ name: String) {
        app.buttons["course_\(name)"].forceTap()
    }
    
    private func goToAttendance(_ description: String) {
        let attendances = self.app.buttons.matching(identifier: "attendance_\(description)")
        attendances.element(boundBy: 0).forceTap()
    }
    
    private func logout() {
        if app.tabBars.element.exists {
            app.tabBars.element.buttons.element(boundBy: 4).tap()
            app.buttons["logout"].tap()
        }
    }
    
    private func wait(_ time: TimeInterval) {
        Thread.sleep(forTimeInterval: time)
    }
    
    private func tapButton(_ identifier: String) {
        app.buttons[identifier].forceTap()
    }
    
    private func login() {
        app.textFields["username"].tap()
        app.textFields["username"].typeText("test2")
        app.secureTextFields["password"].tap()
        app.secureTextFields["password"].typeText("test")
        app.buttons["login"].tap()
        
        XCTAssert(app.tabBars.element.waitForExistence(timeout: 100))
        
        // Wait for view transition
        Thread.sleep(forTimeInterval: 2)
    }
    
    private func screenshot(_ name: String) {
        var screenshot: XCUIScreenshot
        if entireScreen {
            screenshot = XCUIScreen.screens[1].screenshot()
        } else {
            screenshot = app.windows.firstMatch.screenshot()
        }
        
        screenshotIndex += 1
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "\(screenshotIndex)_\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

extension XCUIElement {
    func forceTap() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: .zero)
            coordinate.tap()
        }
    }
}
