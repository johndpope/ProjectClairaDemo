//
//  APICalls.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 22/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation



//APICAlls
class APICall {
    static let shared = APICall()
    
    let baseUrl =  "http://34.252.124.216/midnight/system/api"
    let assetUrl = "http://34.252.124.216/midnight/system/asset_library"
    
    enum APIName {
        static var getCharacters = "/character.json"
        static let getPartsMap = "/parts_map.json"
        static let getParts = "/parts.json"
        static let getPartMeta = "/parts_meta.json"
        static let getContexts = "/contexts.json"
        static let getInterfaces = "/interface.json"
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
    
    
    func saveCharacter_APICall(json: [String : Any], block: @escaping ResponseBlock) {
        let url = URL(string: "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/test@test.com")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    return block(json, true)
                }
            }
            
            block(nil, false)
            
            }.resume()
        
    }

    
    func getSavedCharaters_APICall(username: String, block: @escaping ResponseBlock) {
        let urlString = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/characters/" + username
        
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
    

    
}
