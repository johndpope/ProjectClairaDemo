//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var chartersChoice = [String : String]()
    var part_mapJson = [String : [String : Any]]()
    var parts = [String : [String : [String : Any]]]()
    var partsMeta = [String : Any]()
    var contextJson = [String : Any]()
    var wantedContext = "CX001"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCharters()
        self.get_Context_Data()
    }


    
    func getCharters() {
        APICall.shared.characterAPICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    print(json)
                    if let characters = json["character"] as? [String : Any] {
                        self.chartersChoice = characters["choices"] as! [String  : String]
                        self.get_partMapData()
                    }
                }
            }
        }
    }

    
    func get_partMapData() {
        APICall.shared.partsMap_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : Any]] {
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
                if let json = json as? [String : [String : [String : Any]]] {
                    print(json)
                    self.parts = json
                    self.get_Parts_Meta()
                }
            }
        }
    }
    
    
    func get_Parts_Meta() {
        APICall.shared.parts_meta_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    print(json)
                    self.partsMeta = json
                    self.generateSturcture()
                }
            }
        }
    }

    func get_Context_Data() {
        APICall.shared.context_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : Any]] {
                    print(json)
                    self.contextJson = json[self.wantedContext]!
                }
            }

        }
    }
    
    func generateSturcture() {
        chartersChoice.forEach { (choice, option)  in
            if let partsMapMatch = self.part_mapJson[choice]?[option] as? [String: [String : [String : Any]]] {
                partsMapMatch.forEach({ (part, mapMatch) in
                    mapMatch.forEach({ (matchKey, matchValueObj) in
                        matchValueObj.forEach({ (key, value)  in
                            self.parts[part]?[matchKey]?[key] = value
                        })
                    })
                })
            }
        }
        print(self.parts)
        self.buildSVGs()
    }
    
    
    func buildSVGs() {
        var svgDataDic = [String : [String : Any]]()
        
      parts.forEach { (bodyPart, structure) in
        let fileName = self.generateFileName(fileInfo: structure["file"] as! [String : String])
        let attributes = self.getAttributes(attributeInfo: structure["attributes"] as! [String : String])
        
        var fileWidth = ""
        var fileHeight = ""
        var fileJoints: [String : Any] = [:]
        
        if let fileMeta = self.partsMeta[fileName] {
            //fileWidth = fileMeta["width"]
            fileWidth = (fileMeta as! [String : Any])["width"] as! String
            fileHeight = (fileMeta as! [String : Any])["height"] as! String
            fileJoints = (fileMeta as! [String : Any])["joints"] as! [String : Any]
        }
        
        svgDataDic[bodyPart] = ["body_part" : bodyPart,
                                "file" : fileName,
                                "fileWidth" : fileWidth,
                                "fileHeight" : fileHeight,
                                "joints" : fileJoints]
        
        }
        
        print(svgDataDic)
        
        var contextWidth = ""
        var contextHeight = ""
        var contextPoseData = [String : [String : Any]]()
        var contextPositionX = ""
        var contextPositionY = ""
        if let metaData = contextJson["meta_data"] as? [String : String] {
            contextWidth = metaData["width"] ?? ""
            contextHeight = metaData["height"] ?? ""
        }
        
        if let layers = contextJson["layers"] as? [String : Any] {
            if let zeroValue = layers["0"] as? [String : Any] {
                if let data = zeroValue["data"] as? [String : Any] {
                   
                    if let partLocations = data["part_locations"] as? [String : [String : String]] {
                        contextPoseData = partLocations
                    }
                    
                    if let position = data["position"] as? [String : String] {
                        contextPositionX = position["x"] ?? ""
                        contextPositionY = position["y"] ?? ""
                    }
                    
                }
            }
        }
        
     contextPoseData.forEach { (partName, locations) in
        if let dic2 = svgDataDic[partName] {
            let mergedic = self.merge(dic1: locations, dic2: dic2)
            print(mergedic)
            contextPoseData[partName] = mergedic
        }
        }
        
    }
    
    func merge(dic1: [String : Any], dic2: [String : Any])-> [String : Any] {
        var dic = dic1
        dic2.forEach { (key, value) in
            dic[key] = value
        }
        return dic
    }
    
    func generateFileName(fileInfo: [String : String])-> String {
        var fileName = ""
        var bodyType = ""
        var bodyPart = ""
        var outfitArticle = ""
        var bodyVariation = ""
        var otherCode = ""
        fileInfo.forEach { (key, value) in

            switch key {
            case "body_type_code" :
                bodyType = value
            case "body_part_code" :
                bodyPart = value
            case "outfit_article_code" :
                outfitArticle = value
            case "body_variation_code" :
                bodyVariation = value
            default :
                otherCode = value
            }
            
            if otherCode.isEmpty {
                fileName = bodyPart + "_" + bodyType + "_" + outfitArticle + "_" + bodyVariation + ".svg"
            } else {
                fileName = otherCode + ".svg"
            }
        }
        return fileName
    }
    
    func getAttributes(attributeInfo: [String : String]) {
        print(attributeInfo)
    }
}





//APICAlls
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

    func context_APICall(block: @escaping (Any?, Bool)-> Void) {
        let urlString = "http://34.252.124.216/midnight/system/api/contexts.json"
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
