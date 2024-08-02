//
//  SSInAppViewModel.swift
//  SurveySensumInApp
//
//  Created by akshaygupta on 20/07/24.
//

import Foundation

class SSInAppViewModel{
    
    private let requestModel:SSInAppRequestModel
    var tokenData:CustomTokenKey?
    var fetchedToken:String = ""
    init(requestModel:SSInAppRequestModel) {
        self.requestModel = requestModel
    }
    
    private var baseUrl: String {
        return "https://\(requestModel.subDomain).surveysensum.com/inapp/api/v2/inapp"
        }
    
    func getConfiguration(completion:@escaping(Bool)->()) {
        
        let encodedToken = SSInAppTokenManager.shared.getEncodedToken()
        
        
        let url = "\(baseUrl)/token-data"
        var urlComponents = URLComponents(string: url)!
        
        urlComponents.queryItems = encodedToken.enumerated().map { (index, token) in
            URLQueryItem(name: "token", value: token)
        }
        
        // Get the final URL
        guard let apiUrl = urlComponents.url else{
            return
        }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let self = self else{
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            if let data = data {
                do {
                    let jsonString = String(data: data, encoding: .utf8)
                    //print("Response JSON String: \(jsonString ?? "Empty JSON")")
                    
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SSInAppConfigurationResponse.self, from: data)
                    self.tokenData = getTokenEntry(in: response)
                    // if token entry found in the list
                    if self.tokenData != nil{
                        checkIfUserNeedsToPerformSurvey() ?  completion(true) :  completion(false)
                    }else{
                        completion(false)
                    }
                } catch {
                    //print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func loadSurvey(requestModel:SSInAppRequestModel,completion:@escaping(String)->Void){
        let formData = FormData(contactInfo: requestModel.contactInfo, metadata: requestModel.metadata)
        
        let token = urlEncodedtoken([fetchedToken])
        let apiUrl = "\(baseUrl)/contact-surveyLink?token=\(token[0])"
        
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = formData.data
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            do {
                if let data = data,let jsonString = String(data: data, encoding: .utf8),let jsonData = jsonString.data(using: .utf8) {
                    //print("Survey Link Response: \(jsonString ?? "Empty JSON")")
                    let surveyResponse = try JSONDecoder().decode(SSInAppSurveyResponse.self, from: jsonData)
                    
                    // Original URL from survey response
                    let originalURLString = surveyResponse.result
                    guard !originalURLString.isEmpty, var urlComponents = URLComponents(string: originalURLString) else {
                        DispatchQueue.main.async {
                            completion("")
                        }
                        return
                    }
                    
                    // Parameters to append
                    let additionalParameters: [String: String] = [
                        "vz_inapp_trigger_type": "3",
                        "vz_inapp_trigger_value": requestModel.triggerValue
                    ]
                    
                    // Append additional query items
                    var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
                    for (key, value) in additionalParameters {
                        let newItem = URLQueryItem(name: key, value: value)
                        queryItems.append(newItem)
                    }
                    urlComponents.queryItems = queryItems
                    
                    // Reconstruct the updated URL
                    guard let updatedURL = urlComponents.url?.absoluteString else {
                        DispatchQueue.main.async {
                            completion("")
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completion(updatedURL)
                    }
                }
            } catch {
                //print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getTokenEntry(in response: SSInAppConfigurationResponse) -> CustomTokenKey? {
        for (token, survey) in response.result {
            for rule in survey.inApp.target.rules {
                if rule.values.contains(requestModel.triggerValue) {
                    self.fetchedToken = token
                    return survey
                }
            }
        }
        return nil
    }
    
    
    private func isAnonymous()->Bool{
        // will be anonymous if email will not be present in contact info
        if let contactInfo = requestModel.contactInfo,
           let email = contactInfo["email"] as? String
        {
            return email.isEmpty
        }
        return true
    }
    
    private func checkIfUserNeedsToPerformSurvey()->Bool{
        let status = SSInAppLocalStorage.shared.getSurveyStatus(forKey: fetchedToken)
        switch status{
        case SurveyPerformedStatus.notPerformed.rawValue:
            return true
        case SurveyPerformedStatus.declined.rawValue,SurveyPerformedStatus.performed.rawValue:
            
            if !isAnonymous() && status == SurveyPerformedStatus.performed.rawValue{
                // this will be validated from backend only whether we need to perform survey or not
                return true
            } else{
            guard let  repeatType = tokenData?.inApp.repeatSurvey.first(where: { $0.type.rawValue == status }) else{
                return true
            }
            let repeatStatus = repeatType.status
            if repeatStatus == .on{
                let hasSurveyTimePassed = SSInAppLocalStorage.shared.hasSurveyTimePassed(forToken: fetchedToken, days: repeatType.repeatAfterDays)
                return hasSurveyTimePassed ? true: false
            }else{
                return false
            }
        }
        default:
            return true
        }
    }
}

