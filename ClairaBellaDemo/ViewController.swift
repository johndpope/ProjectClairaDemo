//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var chartersChoice = [String : Any]()
    var part_mapJson = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCharters()
    }


    func getCharters() {
        APICall.shared.characterAPICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    print(json)
                    if let characters = json["character"] as? [String : Any] {
                        self.chartersChoice = characters["choices"] as! [String  :Any]
                        self.get_partMapData()
                    }
                }
            }
        }
    }

    func get_partMapData() {
        APICall.shared.partsMap_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    print(json)
                    self.part_mapJson = json
                    self.get_Parts()
                }
            }

        }
    }
    
    func get_Parts() {
        APICall.shared.parts_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    print(json)
                    self.part_mapJson = json
                }
            }
        }
    }
}

class APICall {
    static let shared = APICall()
    
    
    func characterAPICall(block: @escaping (Any?, Bool)-> Void) {
        let urlString = "http://34.252.124.216/midnight/system/api/character.json"
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
    
    
    func partsMap_APICall(block: @escaping (Any?, Bool)-> Void) {
        let urlString = "http://34.252.124.216/midnight/system/api/parts_map.json"
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
    
    func parts_APICall(block: @escaping (Any?, Bool)-> Void) {
        let urlString = "http://34.252.124.216/midnight/system/api/parts.json"
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
    
    func parts_meta_APICall(block: @escaping (Any?, Bool)-> Void) {
        let urlString = "http://34.252.124.216/midnight/system/api/parts_meta.json"
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
