//
//  CharacterGenerator.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 23/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit

class Character {
    var name = ""
    var choices = [String : String]()
    var charHtml: String?
    var createdDate = ""
}

class CharacterHTMLBuilder {
    
    var defaultChoices = [String : String]()
    var charHTMLString: String?
    var charName = ""
    var wantedContext = "CX001"
    
    fileprivate var part_mapJson = [String : [String : Any]]()
    fileprivate var parts = [String : [String : [String : Any]]]()
    fileprivate var partsMeta = [String : Any]()
    fileprivate var contextJson = [String : Any]()
    
    var resultBlock: (String)->Void = {_ in}

    class func defaultBuilder()->CharacterHTMLBuilder {
        let builder = CharacterHTMLBuilder()
        builder.loadBuildData()
        return builder
    }
    
    func upateCharacter(choices: [String : String]) {
        buildCharHTMLWith(choices: choices, block: nil)
    }
    
    func defaultCharHTML(block: @escaping (String)->Void) {
        buildCharHTMLWith(choices: self.defaultChoices, block: block)
    }
    
    func buildCharHTMLWith(choices: [String : String], block: ((String)->Void)? = nil) {
        if let block = block {
            resultBlock = block
        }
        generateHtml(with: choices)
    }
    
    private func loadBuildData() {
        self.getDefaultChoices()
    }
    
    //call this func for regenerating new character as per user's selected choices.
    fileprivate func generateHtml(with choices: [String : String]) {
        choices.forEach { (choice, option)  in
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
        
        self.buildSVGs()
    }
    
    
    private func buildSVGs() {
        var svgDataDic = [String : [String : Any]]()
        
        parts.forEach { (bodyPart, structure) in
            let fileName = self.generateFileName(fileInfo: structure["file"] as! [String : String])
            let attributes = self.getAttributes(attributeInfo: structure["attributes"] as! [String : String])
            
            var fileWidth = "0"
            var fileHeight = "0"
            var fileJoints: [String : [String : String]] = [:]
            
            
            if let fileMeta = self.partsMeta[fileName + ".svg"] {
                fileWidth = (fileMeta as! [String : Any])["width"] as! String
                fileHeight = (fileMeta as! [String : Any])["height"] as! String
                fileJoints = (fileMeta as! [String : Any])["joints"] as! [String : [String : String]]
                print(fileJoints)
            }
            
            svgDataDic[bodyPart] = ["body_part" : bodyPart,
                                    "file" : fileName,
                                    "param" : attributes,
                                    "width" : fileWidth,
                                    "height" : fileHeight,
                                    "joints" : fileJoints,
                                    "x" : "", "y" : ""] //fill later
        }
        
        
        var contextWidth = "0"
        var contextHeight = "0"
        var contextPoseData = [String : [String : Any]]()
        var contextPositionX = ""
        var contextPositionY = ""
        
        //getting context width and height
        if let metaData = contextJson["meta_data"] as? [String : String] {
            contextWidth = metaData["width"] ?? "0"
            contextHeight = metaData["height"] ?? "0"
        }
        
        //getting part_locations and context position
        if let layers = contextJson["layers"] as? [String : Any] {
            if let zeroValue = layers["0"] as? [String : Any] {
                if let data = zeroValue["data"] as? [String : Any] {
                    
                    if let partLocations = data["part_locations"] as? [String : [String : [String : String]]] {
                        contextPoseData = partLocations
                    }
                    
                    if let position = data["position"] as? [String : String] {
                        contextPositionX = position["x"] ?? ""
                        contextPositionY = position["y"] ?? ""
                    }
                    
                }
            }
        }
        
        //------------------------------------------------------
        //find out the part locatons in proper order
        var partsKey  = [String]()
        let sortedIndexs = contextPoseData.map { Int($0.key)!}.sorted()
        let sortedLocations = sortedIndexs.map {contextPoseData["\($0)"]!}
        var partLocs = [String : Any]()
        
        sortedLocations.forEach { (dic) in
            for (key, value) in dic {
                partLocs[key] = value
                partsKey.append(key)
            }
        }
        
        contextPoseData = partLocs as! [String : [String : Any]]
        //-------------------------------------------------------
        
        //mearge contextpose data with part locations
        contextPoseData.forEach { (partName, locations) in
            if let dic2 = svgDataDic[partName] {
                let mergedic = self.merge(dic1: locations, dic2: dic2)
                //print(mergedic)
                contextPoseData[partName] = mergedic
            }
        }
        
        let firstPartKey = partsKey.first!
        var firstPart: [String : Any] = contextPoseData[firstPartKey]!
        
        
        let specifiedCood = ["x" : contextPositionX, "y" : contextPositionY]
        let fp_width = firstPart["width"] as! String
        let fp_height = firstPart["height"] as! String
        let fp_scale = firstPart["scale"] as! String
        let w = Double(fp_width)!
        let h = Double(fp_height)!
        let s = Double(fp_scale)!
        
        let centralShift  = getCentralObjectCoords(coord: specifiedCood, width: w * s , height: h * s)
        
        //set the position of first part
        contextPoseData[firstPartKey]?["x"] = centralShift["x"]
        contextPoseData[firstPartKey]?["y"] = centralShift["y"]
        
        //calculate and set the actual postion and rotation of each part.
        partsKey.forEach { parentName in
            let parentData = contextPoseData[parentName]!
            var parentDt = parentData
            
            let w = parentData["width"] as! String
            let h = parentData["height"] as! String
            let s = parentData["scale"] as! String
            let parent_scale = Double(s)!
            let parent_width = Double(w)! * parent_scale
            let parent_height = Double(h)! * parent_scale
            parentDt["width"] = "\(parent_width)"
            parentDt["height"] = "\(parent_height)"
            contextPoseData[parentName] = parentDt
            
            if let joints = parentData["joints"] as? [String : [String : String]] {
                joints.forEach({ (childName, internalJointCoords) in
                    if let child = contextPoseData[childName], let cx = child["x"] as? String, cx.isEmpty {
                        print(child)
                        
                        //calculat global joints coord
                        let pX = parentData["x"] as! String
                        let pY = parentData["y"] as! String
                        let parentAngle = parentData["angle"] as! String
                        
                        let ijX = internalJointCoords["x"]!
                        let ijY = internalJointCoords["y"]!
                        //convert into float
                        
                        let pxf = Double(pX) ?? 0
                        let pyf = Double(pY) ?? 0
                        let paf = Double(parentAngle)!
                        let ijxf = Double(ijX)!
                        let ijyf = Double(ijY)!
                        
                        let para1 = ["x" : pxf, "y" : pyf]
                        let para2 = ["x" : ijxf * parent_scale, "y" : ijyf * parent_scale]
                        
                        let globalJointCoords = self.getJointGlobal(objGlobal: para1, jointInternal: para2, angle: paf)
                        
                        let cs = contextPoseData[childName]!["scale"] as! String
                        let childScale = Double(cs)!
                        
                        
                        var jointX = "0"
                        var jointY = "0"
                        
                        if let parentCoodsInChildJoints = (contextPoseData[childName]?["joints"] as? [String : [String : String]])?[parentName] {
                            jointX = parentCoodsInChildJoints["x"]!
                            jointY = parentCoodsInChildJoints["y"]!
                        }
                        
                        let ca = contextPoseData[childName]!["angle"] as! String
                        
                        //convert into double
                        let jointxd = Double(jointX)!
                        let jointyd = Double(jointY)!
                        let childAngle = Double(ca)!
                        
                        let globalChildCoord = self.getObjectGlobal(globalJointCoords, ["x" : jointxd * childScale, "y" : jointyd * childScale], childAngle)
                        contextPoseData[childName]!["x"] = "\(globalChildCoord["x"]!)"
                        contextPoseData[childName]!["y"] = "\(globalChildCoord["y"]!)"
                        
                    }
                })
                
            }
            
        }
        
        //Generate html with contextPoseData.
        generateHTLM(for: contextPoseData, contextSize: CGSize(width: Double(contextWidth)!, height: Double(contextHeight)!))
        
    }
    
    
    private func getJointGlobal(objGlobal: [String : Double], jointInternal : [String : Double], angle: Double)-> [String : Double] {
        let transformCoord = transformCoordWithRotation(jointInternal,  angle)
        let tcx = transformCoord["x"]!
        let tcy = transformCoord["y"]!
        let ogx = objGlobal["x"]!
        let ogy = objGlobal["y"]!
        
        let coord = ["x" : ogx + tcx, "y" : ogy + tcy]
        return coord
    }
    
    private func getObjectGlobal(_ jointGlobal : [String : Double], _ jointInternal: [String : Double], _ angle: Double)-> [String : Double] {
        let transformCoords = transformCoordWithRotation(jointInternal, angle)
        let tcx = transformCoords["x"]!
        let tcy = transformCoords["y"]!
        let jgx = jointGlobal["x"]!
        let jgy = jointGlobal["y"]!
        
        let coord = ["x" : jgx - tcx, "y" : jgy - tcy]
        return coord
    }
    
    private func transformCoordWithRotation(_ jointInternal: [String : Double], _ angle: Double)-> [String : Double] {
        let x = jointInternal["x"]!
        let y = jointInternal["y"]!
        let a = 0 - (angle * Double.pi / 180.0)
        let sin_a = sin(a)
        let cos_a = cos(a)
        let coord =  ["x" : y * sin_a + x * cos_a, "y" : y * cos_a - x * sin_a]
        return coord
    }
    
    private func getCentralObjectCoords(coord: [String : String], width: Double, height: Double)-> [String : String] {
        let cx = Double(coord["x"]!)!
        let cy = Double(coord["y"]!)!
        return ["x" : "\(cx - (width/2))", "y" : "\(cy - (height/2))"]
    }
    
    
    private  func merge(dic1: [String : Any], dic2: [String : Any])-> [String : Any] {
        var dic = dic1
        dic2.forEach { (key, value) in
            dic[key] = value
        }
        return dic
    }
    
    private func generateFileName(fileInfo: [String : String])-> String {
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
                fileName = bodyPart + "_" + bodyType + "_" + outfitArticle + "_" + bodyVariation
            } else {
                fileName = otherCode
            }
        }
        return fileName
    }
    
    private func getAttributes(attributeInfo: [String : String])-> String {
        var attributeString = ""
        attributeInfo.forEach { (atrKey, atrValue) in
            if !atrValue.isEmpty {
                attributeString += atrKey + "=" + atrValue + "&"
            }
        }
        if !attributeString.isEmpty {
            attributeString.characters.removeLast()
        }
        return attributeString
    }
    
    //Generate html from structured json.
    private func generateHTLM(for poseData: [String : [String : Any]], contextSize: CGSize) {
        
        let htmlHeadStyle = "<!DOCTYPE html><html><head><title>test</title><style type=\"text/css\">*{margin:0;pading:0;border:0;} html, body{height:100%;} body{background-color: transparent !important;} div#canvas{position: relative;margin:0 auto;width:\(contextSize.width)px;height:\(contextSize.height)px;border:0px solid lightpink;overflow: hidden;} object{position: absolute;width: 100%;transform-origin: top left;}</style></head>"
        
        
        var htmlBody = "<body><div id=\"canvas\">"
        
        //Generate html for svg images
        poseData.forEach { (bodyPart, data) in
            if let _ = data["x"] as? String, let _ = data["y"] as? String {
                let fileName = data["file"] as! String
                let attributes = data["param"] as! String
                
                if let filePath = Bundle.main.path(forResource: fileName, ofType: "svg") {
                    let pathWithColorAtt = filePath + "?" + attributes
                    
                    htmlBody += "<object id=\"\(bodyPart)\" type=\"image/svg+xml\" name=\"\(bodyPart)\" data=\"file://\(pathWithColorAtt)\" style=\"\(getFileStyle(data: data))\"></object>"
                }
                
                
            }
        }
        
        htmlBody += "</div></body></html>"
        let completeHtml = htmlHeadStyle + htmlBody
        
        self.charHTMLString = completeHtml
        //call result block
        resultBlock(completeHtml)
        
    }
    
    
    private func getFileStyle(data: [String : Any])-> String {
        let top = data["y"] as! String
        let left = data["x"] as! String
        let layer = data["layer"] as! String
        let width = data["width"] as! String
        let height = data["height"] as! String
        let angle = data["angle"] as! String
        
        let styleString = "top:\(top)px; left:\(left)px; z-index:\(layer); width:\(width)px; height:\(height)px; -ms-transform:rotate(\(angle)deg); -webkit-transform:rotate(\(angle)deg); transform:rotate(\(angle)deg);"
        return styleString
    }

}

extension CharacterHTMLBuilder {
    
    func getDefaultChoices() {
        CharBuilderAPI.shared.getCharters_json { choices in
            self.defaultChoices = choices
            self.getPartsMap()
        }
    }
    
    func getPartsMap() {
        CharBuilderAPI.shared.get_partMap_json { partMap in
            self.part_mapJson = partMap
            self.getParts()
        }
    }
    
    func getParts() {
        CharBuilderAPI.shared.get_Parts_json { parts in
            self.parts = parts
            self.getPartsMeta()
        }
    }
    
    func getPartsMeta() {
        CharBuilderAPI.shared.get_PartsMeta_json { partMeta in
            self.partsMeta = partMeta
            self.getContexts()
        }
    }
    
    func getContexts() {
        CharBuilderAPI.shared.get_Context_json { contexts in
            self.contextJson = contexts[self.wantedContext]!
            self.generateHtml(with: self.defaultChoices)
        }
    }

}

    



class CharBuilderAPI {
    static let shared = CharBuilderAPI()
    
    func getInterface_json(block: @escaping ([ChoiceMenu])->Void) {
        APICall.shared.interface_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : Any]] {
                    let menus =  json.map({ (key, value) -> ChoiceMenu in
                        return ChoiceMenu(value)
                    })
                    
                    block(menus)
                }
            }
        }
    }
    

    func getCharters_json(block: @escaping ([String : String])-> Void) {
        APICall.shared.characterAPICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    if let characters = json["character"] as? [String : Any] {
                        let chartersChoice = characters["choices"] as! [String  : String]
                        block(chartersChoice)
                    }
                }
            } else {
                //
            }
        }
    }
    
    
    func get_partMap_json(block: @escaping ([String : [String : Any]])-> Void) {
        APICall.shared.partsMap_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : Any]] {
                    block(json)
                }
            } else {
                //
            }
            
        }
    }
    
    func get_Parts_json(block: @escaping ([String : [String : [String : Any]]])->Void) {
        APICall.shared.parts_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : [String : Any]]] {
                    block(json)
                }
            } else {
                //
            }
        }
    }
    
    
    func get_PartsMeta_json(block: @escaping ([String : Any])-> Void) {
        APICall.shared.parts_meta_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    block(json)
                }
            } else {
                //
            }
        }
    }
    
    func get_Context_json(block: @escaping ([String : [String : Any]])->Void) {
        APICall.shared.context_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : [String : Any]] {
                    block(json)
                }
            } else {
                //
            }
            
        }
    }
    
    
}




class ChoiceMenu {
    var title = ""
    var icon  = ""
    var heading = ""
    var choice = CharacterChoice()
    
    var selected = false
    
    init(_ json: [String : Any]) {
        title = (json["title"] as? String) ?? ""
        icon = APICall.shared.assetUrl + "/" + ((json["icon"] as? String) ?? "")
        heading = (json["heading"] as? String) ?? ""
        
        if let jsChoice = json["choice"] as? [String : Any] {
            choice = CharacterChoice(jsChoice)
        }
    }
}

class CharacterChoice {
    var choiceId = ""
    var options = [ChoiceOption]()
    
    convenience init(_ json : [String : Any]) {
        self.init()
        
        choiceId = (json["choice_id"] as? String) ?? ""
        
        if let jsOptions = json["options"] as? [String : [String : Any]] {
            options = jsOptions.map({ (key, option) -> ChoiceOption in
                return ChoiceOption(option)
            })
        }
    }
}

class ChoiceOption {
    var name = ""
    var choice = CharacterChoice ()
    
    var selected = false
    convenience init(_ json: [String : Any]) {
        self.init()
        name = (json["name"] as? String) ?? ""
        
        if let jsChoice = json["choice"] as? [String : Any] {
            choice = CharacterChoice(jsChoice)
        }
        
    }
}

