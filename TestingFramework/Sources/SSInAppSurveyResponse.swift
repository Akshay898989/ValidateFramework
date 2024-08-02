//
//  SSInAppSurveyResponse.swift
//  TestingFramework
//
//  Created by akshaygupta on 02/08/24.
//

import Foundation

struct SSInAppSurveyResponse: Codable {
    let statusCode: Double
    let result: String
    let etag: String?
    let errors: [String]
    let message: String
    let corelationId: String?
}
