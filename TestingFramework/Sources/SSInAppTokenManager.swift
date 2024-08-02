//
//  SSInAppTokenManager.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

import Foundation

@objc public class SSInAppTokenManager:NSObject {
    
    @objc public static let shared = SSInAppTokenManager()
    
    private var token: [String] = []
    
    private override init() {
        // Initialize with default token if needed
    }
    
    @objc public func setToken(_ token: [String]) {
        self.token = token
    }
    
    public func getToken() -> [String] {
        return token
    }
    
    public func getEncodedToken() -> [String] {
        return urlEncodedtoken(token)
    }
}

