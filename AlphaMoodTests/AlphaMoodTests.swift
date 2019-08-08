//
//  AlphaMoodTests.swift
//  AlphaMoodTests
//
//  Created by Абылайхан on 7/31/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import XCTest
@testable import AlphaMood
class AlphaMoodTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    Pin.getPin(completion: { (pin) in
            XCTAssertEqual(pin, "0322")
        })
        
    }
    func testCreateExistingPerson(){
        let personM = PersonModelManager()
        let person = personM.createPerson(id: "2jiSIuRTFfOpKjRIN0SuLB4xu673") { (person) in
            XCTAssertEqual(person.isPinned, true)
        }
    }
    
    func testGetFixedComments() {
        let svm = SecondPageViewModel(personModel: PersonModel(userId: "!23", mood: .neutral, date: nil, lastMood: nil, isPinned: nil))
        svm.getFixedComment(comment: "Комары много и офис жаркий") { (comments) in
            for i in comments{
                XCTAssertEqual("комар", i)
            }
        }
    }
    
    func testGetComments() {
        let commentsViewModel = CommentsViewModel()
        commentsViewModel.changeMood(mood: MoodModel.positive)
        commentsViewModel.getComments {
            for comment in commentsViewModel.comments{
                XCTAssertEqual(comment.comment, "кофемашинка")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
