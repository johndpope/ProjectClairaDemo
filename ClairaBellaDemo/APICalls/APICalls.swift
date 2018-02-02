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
        if let user_deatils = UserDefaults(suiteName: appGroupName)!.value(forKey: "user_details")as? [String:Any] {
            return user_deatils["email"] as? String
        }
        return nil
    }
    
    private init() {
        
    }
    
    
    //MARK:-assets version and key
    
    var assetLocalVersion: String {
        if let savedLocalVersion = UserDefaults.standard.string(forKey: assetVersionKey) {
            return savedLocalVersion
        }
        return "v1.0"
    }
    
    let assetVersionKey = "AssetVersion"
    
    
    //MARK:-API Name
    
    enum APIName {
        static let baseUrl =  "http://builder.midnightplatform.net/midnight/system/api/"
        
        static let assetUrl = "http://builder.midnightplatform.net/midnight/system/asset_library/"

        static var API_VERSION = "v1.0"
        static var ASSETS_LOCAL_VERSION = "v1.0.1"

        static var getCharacters    = baseUrl + API_VERSION + "/claireabella/character"
        static let getPartsMap      = baseUrl + API_VERSION + "/claireabella/parts_map"
        static let getParts         = baseUrl + API_VERSION + "/claireabella/parts"
        static let getPartMeta      = baseUrl + API_VERSION + "/claireabella/parts_meta"
        static let getContexts      = baseUrl + API_VERSION + "/claireabella/contexts"
        static let getEmojisContexts = baseUrl + API_VERSION + "/claireabella/emojis"

        static let getInterfaces = baseUrl + API_VERSION + "/claireabella/app_interface"
        
        static let characterAssetsDownload = assetUrl +  "app/claireabella/" + APICall.shared.assetLocalVersion + ".zip"
        
    }
    
    
    
    typealias ResponseBlock = (Any?, Bool)-> Void
    
    
    func encode(json: Any, fileName: String) {
        UserDefaults(suiteName: appGroupName)?.setValue(json, forKey: fileName)
    }
    
    func decodeJsonFrom(fileName: String)-> Any? {

        return  UserDefaults(suiteName: appGroupName)?.object(forKey: fileName)
    }
    
    //API Calls methods
    
    
    func interface_APICall(block: @escaping ResponseBlock) {
        if let localJson = decodeJsonFrom(fileName: "InterfaceJson") {
            block(localJson, true)
        } else {
            
            let urlString =  APIName.getInterfaces
            let url = URL(string: urlString)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                        self.encode(json: json, fileName: "InterfaceJson")
                        return block(json, true)
                    }
                }
                
                block(nil, false)
                }.resume()
        }
    }

    func characterAPICall(block: @escaping ResponseBlock) {
        
        if let localJson = decodeJsonFrom(fileName: "CharacterJson") {
            block(localJson, true)
        } else {
            let urlString = APIName.getCharacters
            let url = URL(string: urlString)!
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                        self.encode(json: json, fileName: "CharacterJson")
                        return block(json, true)
                    }
                }
                
                block(nil, false)
                }.resume()
            
        }
    }
    
    
    func partsMap_APICall(block: @escaping ResponseBlock) {
        if let localJson = decodeJsonFrom(fileName: "PartMapJson") {
            block(localJson, true)
        } else {
        let urlString = APIName.getPartsMap
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    self.encode(json: json, fileName: "PartMapJson")
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        }
        
    }
    
    func parts_APICall(block: @escaping ResponseBlock) {
        
        if let localJson = decodeJsonFrom(fileName: "PartsJson") {
            block(localJson, true)
            
        } else {
            
        let urlString =  APIName.getParts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    self.encode(json: json, fileName: "PartsJson")
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        }
    }
    
    func parts_meta_APICall(block: @escaping ResponseBlock) {
        if let localJson = decodeJsonFrom(fileName: "PartsMetaJson") {
            block(localJson, true)
            
        } else {

        let urlString =  APIName.getPartMeta
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    self.encode(json: json, fileName: "PartsMetaJson")
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        }
    }
    
    func context_APICall(block: @escaping ResponseBlock) {
        if let localJson = decodeJsonFrom(fileName: "CharacterContextJson") {
            block(localJson, true)
            
        } else {
            
        let urlString =  APIName.getContexts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    self.encode(json: json, fileName: "CharacterContextJson")
                    return block(json, true)
                }
            }
            
            block(nil, false)
            }.resume()
        }
    }
    
    func emojis_context_APICall(block: @escaping ResponseBlock) {
        if let localJson = decodeJsonFrom(fileName: "EmojiContextJson") {
            block(localJson, true)
        } else {
            
        let urlString =  APIName.getEmojisContexts
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                    DispatchQueue.main.async {
                        self.encode(json: json, fileName: "EmojiContextJson")
                        block(json, true)
                    }
                    return
                }
            }
            
            block(nil, false)
            }.resume()
        }
    }

    
    
    
    func createNewCharacter_APICall(json: [String : Any], block: @escaping ResponseBlock) {
        guard let userEmail = currentUserEmail else {block(nil, false); return}
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

    
    func updateUser_APICall(email: String, params: [String : Any], block: @escaping ResponseBlock) {
        
        // let urlString  = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/users/\(email)"
        let urlString = "https://yff8t38cs8.execute-api.eu-west-1.amazonaws.com/latest/users/\(email)/"
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




func documetDirectoryURL()-> URL {
    let fileManager = FileManager.default
    let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    return documentDirectory
}




