//
//  Utilities.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

import Foundation

func urlEncodedtoken(_ token: [String]) -> [String] {
    // URL encode the Base64 string directly
    let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~")
    var urlEncodedToken:[String] = []
    for token in token{
        urlEncodedToken.append(token.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? "")
    }
    
    return urlEncodedToken
}

// Function to URL-encode a dictionary
func urlEncode(_ parameters: [String: String]) -> String {
    return parameters.map { key, value in
        let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(escapedKey)=\(escapedValue)"
    }.joined(separator: "&")
}

// Function to encode a dictionary to Base64
func encodeToBase64(_ dictionary: [String: Any]) -> String? {
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .fragmentsAllowed)
        return jsonData.base64EncodedString()
    } catch {
        return nil
    }
}

