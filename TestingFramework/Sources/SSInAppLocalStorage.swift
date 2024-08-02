//
//  SSSurveyLocalStorage.swift
//  Pods-SurveyDemo
//
//  Created by akshaygupta on 12/07/24.
//

import Foundation


class SSInAppLocalStorage {
    static let shared = SSInAppLocalStorage()
    let userDefaults = UserDefaults.standard
    private init() { }
    
    
    var surveyPerformedStatus: [String: Int] {
        get {
            return userDefaults.surveyPerformedStatus
        }
        set {
            userDefaults.surveyPerformedStatus = newValue
        }
    }
    
    var surveyPerformTime: [String: Date] {
        get {
            return userDefaults.surveyPerformTime
        }
        set {
            userDefaults.surveyPerformTime = newValue
        }
    }
    
    func getSurveyStatus(forKey key: String) -> Int? {
        return surveyPerformedStatus[key]
    }
    
    func hasSurveyTimePassed(forToken token: String, days:Int) -> Bool {
        guard let storedTime = surveyPerformTime[token] else{
            return true
        }
        
        let currentTime = Date()
        let calendar = Calendar.current
        
        if let daysDifference = calendar.dateComponents([.day], from: storedTime, to: currentTime).day {
            if daysDifference > days{
                removeSurveyData(forToken: token)
                return true
            }else{
                return false
            }
        }
        
        return false
    }
    private func removeSurveyData(forToken token: String) {
        var currentStatus = surveyPerformedStatus
        var currentTime = surveyPerformTime
        
        currentStatus.removeValue(forKey: token)
        currentTime.removeValue(forKey: token)
        
        surveyPerformedStatus = currentStatus
        surveyPerformTime = currentTime
    }
}


