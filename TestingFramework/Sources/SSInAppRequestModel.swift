//
//  SSInAppRequestModel.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 28/07/24.
//

import Foundation

public class SSInAppRequestModel:NSObject{
    @objc public var contactInfo: [String: Any]?
    @objc public var metadata: [String: Any]?
    @objc public var triggerValue:String
    @objc public var subDomain:String
    @objc public init(contactInfo: [String : Any]? = nil, metadata: [String : Any]? = nil, triggerValue: String, subDomain: String) {
        self.contactInfo = contactInfo
        self.metadata = metadata
        self.triggerValue = triggerValue
        self.subDomain = subDomain
    }
}

