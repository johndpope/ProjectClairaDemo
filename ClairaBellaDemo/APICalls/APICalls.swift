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
    
    
    //API Calls methods
    
    func characterAPICall(block: @escaping ResponseBlock) {
        let urlString = APIName.getCharacters
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
        let urlString = APIName.getPartsMap
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
        let urlString =  APIName.getParts
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
        let urlString =  APIName.getPartMeta
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
        let urlString =  APIName.getContexts
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
        let urlString =  APIName.getEmojisContexts
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
        let urlString =  APIName.getInterfaces
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



protocol CharacterType {
    var charHtml: String {get set}
}


class Emoji: CharacterType {
    var charHtml = ""
    var key: String = ""
    var characterCreatedDate = ""
}

struct CharBackground {
    var icon = ""
    var image = ""
}



class Character: NSCopying, CharacterType {
    
    var name = ""
    var choices = [String : String]()
    var charHtml: String = ""
    var createdDate = ""
    var alive = false
    var characterBackground: CharBackground?
    
    var editMode = false//used for creating emojis after user update the character.
    
    static let characterContext = "CX001"
    
    var emojis = [Emoji]()
    
    var isMainChar: Bool {
        if let mainCharDate = UserDefaults.standard.value(forKey: "MainCharacter") as? String {
            return createdDate == mainCharDate
        } else {
            return false
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Character()
        copy.name = self.name
        copy.choices = self.choices
        copy.charHtml = self.charHtml
        copy.createdDate = self.createdDate
        copy.alive = self.alive
        return copy
    }
    
    static var myCharacters = [Character]() {
        didSet {
            loadingFinish = true
        }
    }
    static var loadingFinish = false
    
    static var mainCharacter: Character? {
        return myCharacters.filter({$0.isMainChar}).first
    }
    
    
    //
}


