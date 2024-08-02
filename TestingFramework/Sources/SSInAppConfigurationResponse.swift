//
//  SSInAppConfigurationResponse.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

import Foundation

struct SSInAppConfigurationResponse: Codable {
    let statusCode: Int
    let result: [String: CustomTokenKey]
    let etag: String?
    let errors: [String]
    let message: String
    let corelationID: String?

    enum CodingKeys: String, CodingKey {
        case statusCode, result, etag, errors, message
        case corelationID = "corelationId"
    }
}

struct CustomTokenKey: Codable {
    let inApp: InApp
    let responseLimit: ResponseLimit
}



struct InApp: Codable {
    let sidebarText: String?
    let sidebarColour: String
    let delayTime: Int
    let target: Target
    let layout: InAppLayout
    let position: Int
    let campID: String
    let popupSize: PopupSize
    let launchType: Int
    let repeatSurvey: [RepeatSurvey]
    let autoCloseSurvey: Bool
    let surveyGUID, id: String
    let hideCloseButton: Bool
    enum CodingKeys: String, CodingKey {
        case sidebarText, sidebarColour, delayTime, target, layout, position
        case campID = "campId"
        case popupSize, launchType, repeatSurvey, autoCloseSurvey, hideCloseButton
        case surveyGUID = "surveyGuid"
        case id
    }
}

struct Target: Codable {
    let type: Int
    let rules: [Rule]
    let condition: String?
    let field: String?
    let targetOperator: String?
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case type, rules, condition, field
        case targetOperator = "operator"
        case values
    }
}

struct Rule: Codable {
    let type: Int
    let rules: [Rule]
    let condition: String?
    let field: String?
    let ruleOperator: String?
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case type, rules, condition, field
        case ruleOperator = "operator"
        case values
    }
}

struct PopupSize: Codable {
    let width, height, unit: Int
}

struct RepeatSurvey: Codable {
    let type: RepeatType
    let repeatAfterDays: Int
    let status:RepeatStatus
    let responseStatus: [Int]
}

struct ResponseLimit: Codable {
    let enabled: Bool
    let tryAfter: String?
}


enum InAppLayout:Int,Codable{
    case fullScreen = 1
    case popup = 2
    case embedInView = 4
}

enum RepeatStatus:Int,Codable{
    case off = 1
    case on = 2
}
enum RepeatType:Int,Codable{
    case userDeclined = 1
    case reOccuring = 2
}
enum RepeatResponseStatus:Int,Codable{
    case new = 1
    case partial = 2
    case completed = 3
    case terminated = 4
}



enum SurveyPerformedStatus:Int{
    case notPerformed = 0
    case declined = 1
    case performed = 2
}

