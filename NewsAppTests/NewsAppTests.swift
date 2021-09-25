//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Javier Sapia on 01/09/2021.
//

import XCTest
@testable import NewsApp

class NewsAppTests: XCTestCase {

    func testGuardianUrlBuilder() {
        let expectedUrl: String = "https://content.guardianapis.com/search?api-key=209236ce-40af-4151-ae50-0eb3bab98453&show-fields=thumbnail,headline,trailText,body,firstPublicationDate,apiUrl"
        if let url: String = GuardianURL.Build().url?.absoluteString {
            XCTAssertEqual(url, expectedUrl)
        } else {
            XCTFail("nil")
        }
    }
    
    func testGuardianUrlBuilderWithParams() {
        let expectedUrl: String = "https://content.guardianapis.com/search?api-key=209236ce-40af-4151-ae50-0eb3bab98453&show-fields=thumbnail,headline,trailText,body,firstPublicationDate,apiUrl&section=technology"
        if let url: String = GuardianURL.Build(section: "technology").url?.absoluteString {
            XCTAssertEqual(url, expectedUrl)
        } else {
            XCTFail("nil")
        }
    }
    
    func testGuardianUrlBuildFromApi() {
        let noParamsApiUrl: String = "https://content.guardianapis.com/tv-and-radio/2021/sep/05/vigil-episode-three-recap-motives-emerge-amid-the-murky-mystery"
        let expectedUrl: String = "https://content.guardianapis.com/tv-and-radio/2021/sep/05/vigil-episode-three-recap-motives-emerge-amid-the-murky-mystery?api-key=209236ce-40af-4151-ae50-0eb3bab98453&show-fields=thumbnail,headline,trailText,body,firstPublicationDate,apiUrl"
        if let url: String = GuardianURL.BuildFromApiUrl(url: noParamsApiUrl).url?.absoluteString {
            XCTAssertEqual(url, expectedUrl)
        } else {
            XCTFail("nil")
        }
    }
        
}
