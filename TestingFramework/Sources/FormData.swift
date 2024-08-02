//
//  FormData.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

import Foundation

struct FormData {
    var contactData: String?
    var metadataProperties: String?

    init(contactInfo: [String: Any]?, metadata: [String: Any]?) {
        if let contactInfo = contactInfo {
            self.contactData = encodeToBase64(contactInfo)
        }
        
        if let metadata = metadata {
            self.metadataProperties = encodeToBase64(metadata)
        }
    }

    var data: Data? {
        var bodyDict: [String: String] = [:]
        
        if let contactData = contactData {
            bodyDict["contactData"] = contactData
        }
        
        if let metadataProperties = metadataProperties {
            bodyDict["metadataProperties"] = metadataProperties
        }
        
        let encodedString = urlEncode(bodyDict)
        return encodedString.data(using: .utf8)
    }
}

