//
//  APICalls.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 22/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation


let appGroupName = "group.claireabella.com"
//APICAlls
class APICall {
    static let shared = APICall()
    var currentUserEmail: String? {
        if let user_deatils = UserDefaults(suiteName: appGroupName)!.value(forKey: "user_details")as? [String:String] {
            return user_deatils["email"]
        }
        return nil
    }
    
    private init() {
        
    }
    
    //
    //let baseUrl =  "http://34.252.124.216/midnight/system/api"
    let baseUrl =  "http://builder.midnightplatform.net/midnight/system/api/"

    //let assetUrl = "http://34.252.124.216/midnight/system/asset_library"
    let assetUrl = "http://builder.midnightplatform.net/midnight/system/asset_library/interface/v1.0/"

    enum APIName {
        static var apiVersion = "v1.0"

        static var getCharacters    = apiVersion + "/claireabella/character"
        static let getPartsMap      = apiVersion + "/claireabella/parts_map"
        static let getParts         = apiVersion + "/claireabella/parts"
        static let getPartMeta      = apiVersion + "/claireabella/parts_meta"
        static let getContexts      = apiVersion + "/claireabella/contexts"
        static let getEmojisContexts = apiVersion + "/claireabella/emojis"

        static let getInterfaces = apiVersion + "/claireabella/web_interface"
    }
    
    typealias ResponseBlock = (Any?, Bool)-> Void
    
    func characterAPICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getCharacters
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    
    func partsMap_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getPartsMap
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    func parts_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getParts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    func parts_meta_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getPartMeta
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    func context_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getContexts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
    }
    
    func emojis_context_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getEmojisContexts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            block(nil, false)
            }.resume()
    }

    
    func interface_APICall(block: @escaping ResponseBlock) {
        let urlString = baseUrl + APIName.getInterfaces
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
    }
    
    
    func createNewCharacter_APICall(json: [String : Any], block: @escaping ResponseBlock) {
        guard let userEmail = currentUserEmail else {return}
        //let userEmail = "test@test.com"

        let url = URL(string: "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/\(userEmail)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                block(nil, false)
            }
            
            }.resume()
        
    }

    
    func getSavedCharaters_APICall(block: @escaping ResponseBlock) {
        guard let userEmail = currentUserEmail else {return}
        //let userEmail = "test@test.com"

        let urlString = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/\(userEmail)"
        
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        
    }
    
    
    func deleteCharacter_APICall(createdDate: String, block: @escaping ResponseBlock) {
        guard let userEmail = currentUserEmail else {return}
        //let userEmail = "test@test.com"

        let urlString = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/\(userEmail)?date_created=\(createdDate)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                block(nil, false)
            }
            
            }.resume()
        
    }
    
    func updateCharacter_APICall(params: [String : Any], createdDate: String, block: @escaping ResponseBlock) {
        guard let userEmail = currentUserEmail else {return}
        //let userEmail = "test@test.com"

        let urlString  = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/\(userEmail)?date_created=\(createdDate)"
        let url = URL(string: urlString)!
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = data
       
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                block(nil, false)
            }
            
            }.resume()
        
    }

    
    func signupUser_APICall(email: String, params: [String : Any], block: @escaping ResponseBlock) {
        
        let urlString  = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/users/\(email)"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                block(nil, false)
            }
            
            }.resume()
        
    }
    
    func loginUser_APICall(email: String, params: [String : Any], block: @escaping ResponseBlock) {
        
       // let urlString  = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/users/\(email)"
        let urlString = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/users/\(email)/login"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        block(json, true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                block(nil, false)
            }
            
            }.resume()
        
    }

}
