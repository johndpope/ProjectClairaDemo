//
//  CharacterGenerator.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 23/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit




class CharacterHTMLBuilder {
    
    static let shared = CharacterHTMLBuilder()
    
    var defaultChoices = [String : String]()
    var charHTMLString: String?
    var charName = ""
    var contextKey = "CX001"
   
    var headWearsForHideHair = ["Turban Wrap", "Tie Bow Wrap", "Knotted Wrap", "Head Shawl"]

    enum CharacterType {
        case character, emoji
    }
    
     private init() {
        
    }
    
    init(builder: CharacterHTMLBuilder) {
        self.defaultChoices = builder.defaultChoices
        part_mapJson = builder.part_mapJson
        parts = builder.parts
        partsMeta = builder.partsMeta
        contextJson = builder.contextJson
        currentContext = builder.currentContext
        emojisContextJson = builder.emojisContextJson
    }
    
    //block call when finish loading of all the character related apis.
    var didFinishLoadingAllCharacterAPIBlock: ((Bool)->Void)?
    
    var characterType = CharacterType.character
    
    fileprivate var part_mapJson = [String : [String : Any]]()
    fileprivate var parts = [String : [String : [String : Any]]]()
    fileprivate var partsMeta = [String : Any]()
    fileprivate var contextJson = [String : Any]()
    fileprivate var currentContext = [String : Any]()
    fileprivate var emojisContextJson = [String : Any]()
    
    var resultBlock: (String)->Void = {_ in}
    var deviceScaleFactor = 0.8
    
    func upateCharacter(choices: [String : String]) {
        buildCharHTMLWith(choices: choices, block: nil)
    }
    
    func defaultCharHTML(block: @escaping (String)->Void) {
        buildCharHTMLWith(choices: self.defaultChoices, block: block)
    }
    
    func buildCharHTMLWith(for type:CharacterType = .character, choices: [String : String], for contextKey: String = Character.characterContext, block: ((String)->Void)? = nil) {
        self.contextKey = contextKey
        let scale = SCREEN_WIDTH == 320 ? 1.0 : 1.05
        deviceScaleFactor = type == .character ? scale : 1.30
       
        if let block = block {
            resultBlock = block
        }
        
        self.buildStart(for: type, choices: choices, block: block)

    }
    
    func loadBuildData(block: @escaping (Bool)->Void) {
        didFinishLoadingAllCharacterAPIBlock = block
        self.getDefaultChoices()
    }
    
    //call this func for regenerating new character as per user's selected choices.
    fileprivate func buildStart(for type:CharacterType,  choices: [String : String], block: ((String)->Void)? = nil) {
        let cntxtJson = type == .character ? contextJson : emojisContextJson
        guard let context = cntxtJson[contextKey] as? [String : Any] else {return}
        characterType = type
        currentContext = context
        var userChoices = choices
        if let layers = currentContext["layers"] as? [String : Any] {
            if let zeroValue = layers["0"] as? [String : Any] {
                if let data = zeroValue["data"] as? [String : Any] {
                    
                    if let fixedChoices = data["fixed_choice"] as? [String : String] {
                        
                        fixedChoices.forEach({userChoices[$0] = $1})
                    }
                    
                }
            }
        }
        
        
        var hideHair = false
        
        //remove hair_style if head_wear option belongs to hideHair collection.
        userChoices.forEach { (choice,  option) in
            if choice == "head_wear" && headWearsForHideHair.contains(option) {
                hideHair = true
            }
        }
        
        userChoices.forEach { (choice, option)  in
        
            if let partsMapMatch = self.part_mapJson[choice]?[option] as? [String: [String : [String : Any]]] {
                partsMapMatch.forEach({ (part, mapMatch) in
                    mapMatch.forEach({ (matchKey, matchValueObj) in
                        matchValueObj.forEach({ (key, value)  in
                            var vlue = value
                            if key == "hair_style_code" && hideHair {
                                self.parts[part]?[matchKey]?["hideHair"] = "true"
                            } else {
                                self.parts[part]?[matchKey]?["hideHair"] = "false"
                            }
                            self.parts[part]?[matchKey]?[key] = vlue
                        })
                    })
                })
            } else {
                self.parts[choice]?["file"]?["hair_style_code"] = ""
            }
        }
        
        self.buildSVGs(block)
    }
    
    
    private func buildSVGs(_ block: ((String)->Void)? = nil) {
        var svgDataDic = [String : [String : Any]]()
        
        parts.forEach { (bodyPart, structure) in
            var fileWidth = "0"
            var fileHeight = "0"
            var fileJoints: [String : [String : String]] = [:]
            var fileName = ""
            var attributes = ""
            var hideHair = ""
            if !structure.isEmpty {
                
                
                fileName = self.generateFileName(fileInfo: structure["file"] as! [String : String])
                attributes = self.getAttributes(attributeInfo: structure["attributes"] as! [String : String])
                
                hideHair = (structure["file"] as! [String : String])["hideHair"] ?? "false"
                
                if let fileMeta = self.partsMeta[fileName + ".svg"] {
                    fileWidth = RConverter.string((fileMeta as! [String : Any])["width"])
                    fileHeight = RConverter.string((fileMeta as! [String : Any])["height"])
                    fileJoints = ((fileMeta as! [String : Any])["joints"] as? [String : [String : String]]) ?? [:]
                }
            }
            
            svgDataDic[bodyPart] = ["body_part" : bodyPart,
                                    "file" : fileName,
                                    "param" : attributes,
                                    "width" : fileWidth,
                                    "height" : fileHeight,
                                    "joints" : fileJoints,
                                    "x" : "", "y" : "",
                                    "hideHair" : hideHair] //fill later
        }
        
        
        var contextWidth = "0"
        var contextHeight = "0"
        var contextPoseData = [String : [String : Any]]()
        var contextPositionX = ""//-
        var contextPositionY = ""//-
        
        //getting context width and height
        if let metaData = currentContext["meta_data"] as? [String : String] {
            contextWidth = metaData["width"] ?? "0"
            contextHeight = metaData["height"] ?? "0"
        }
        
        //getting part_locations and context position
        if let layers = currentContext["layers"] as? [String : Any] {
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
                if !partsKey.contains(key) {
                    partsKey.append(key)

                }

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
        
        guard let firstPartKey = partsKey.first else {return}
        var firstPart: [String : Any] = contextPoseData[firstPartKey]!
        
        let postionFactor:Double = characterType == .character ? 1 : 2.0
        
        let cntxPositionX = Double(contextPositionX)! * postionFactor
        let cntxPostionY = Double(contextPositionY)! * postionFactor
        
        let specifiedCood = ["x" : "\(cntxPositionX)", "y" : "\(cntxPostionY)"]
        let fp_width = firstPart["width"] as! String
        let fp_height = firstPart["height"] as! String
        let fp_scale = firstPart["scale"] as! String
        let w = Double(fp_width)! * deviceScaleFactor
        let h = Double(fp_height)! * deviceScaleFactor
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
            let parent_scale = Double(s)! * deviceScaleFactor
            let parent_width = Double(w)! * parent_scale
            let parent_height = Double(h)! * parent_scale

            parentDt["height"] = "\(parent_height)"
            parentDt["width"] = "\(parent_width)"

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
                        
                        let para1 = ["x" : pxf, "y" : pyf]//--------
                        let para2 = ["x" : ijxf * parent_scale, "y" : ijyf * parent_scale]
                        
                        let globalJointCoords = self.getJointGlobal(objGlobal: para1, jointInternal: para2, angle: paf)
                        
                        let cs = contextPoseData[childName]!["scale"] as! String
                        let childScale = Double(cs)! * deviceScaleFactor
                        
                        
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
        let contextSize: CGSize
        if characterType == .character {
            contextSize = CGSize(width: Double(contextWidth)!, height: Double(contextHeight)!  )
        } else {
            contextSize = CGSize(width: 200, height: 200 )
        }
        
        generateHTLM(for: contextPoseData, contextSize: contextSize, block: block)
        
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
                if key != "hideHair" {
                    fileName = otherCode
                }
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
    private func generateHTLM(for poseData: [String : [String : Any]], contextSize: CGSize, block: ((String)->Void)? = nil) {
        
        let htmlHeadStyle = "<!DOCTYPE html><html><head><title>test</title><style type=\"text/css\">*{margin:0;pading:0;border:0;} html, body{height:100%;} body{background-color: transparent !important;} div#canvas{position: relative;margin:0 auto;width:\(contextSize.width)px;height:\(contextSize.height)px;border:0px solid lightpink;overflow: hidden;} object{position: absolute;width: 100%;transform-origin: top left;}</style></head>"
        
        
        var htmlBody = "<body><div id=\"canvas\">"
        
        //Generate html for svg images
        poseData.forEach { (bodyPart, data) in
            print(data)
                if let _ = data["x"] as? String, let _ = data["y"] as? String {
                    let fileName = data["file"] as! String
                    let attributes = data["param"] as! String
                    
                    if let hideHair = data["hideHair"] as? String, hideHair == "false" {
                        let filePath = documetDirectoryURL().appendingPathComponent("character/claireabella/v1.0/\(fileName).svg").path
                        
                        let pathWithColorAtt = filePath + "?" + attributes
                        
                        htmlBody += "<object id=\"\(bodyPart)\" type=\"image/svg+xml\" name=\"\(bodyPart)\" data=\"file://\(pathWithColorAtt)\" style=\"\(getFileStyle(data: data))\"></object>"

                    }
                    
                    
                }
            }
        
        htmlBody += "</div></body></html>"
        let completeHtml = htmlHeadStyle + htmlBody
        
        self.charHTMLString = completeHtml
        //call result block
        DispatchQueue.main.async {
            if let block = block {
                block(completeHtml)
            } else{
                self.resultBlock(completeHtml)
            }
        }
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
            self.contextJson = contexts
            self.buildStart(for: .character, choices: self.defaultChoices)
            self.getEmojisContexts()
        }
    }

    func getEmojisContexts() {
        
        CharBuilderAPI.shared.get_emojisContext_json { contexts in
            self.emojisContextJson = contexts
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CharacterBuilderJsonLoadingFinish"), object: nil, userInfo: nil)
            self.didFinishLoadingAllCharacterAPIBlock?(true)
        }
    }

}

    



class CharBuilderAPI {
    static let shared = CharBuilderAPI()
    
    func getInterface_json(block: @escaping ([ChoiceMenu])->Void) {
        APICall.shared.interface_APICall { (json, isSuccess) in
            if isSuccess {
                if let json = json as? [String : Any] {
                    
                    //Parsing Interface menu jsons
                    var menus = [ChoiceMenu]()
                    
                    if let jsonData = json["data"] as? [[String : Any]] {
                        menus =  jsonData.map({ obj -> ChoiceMenu in
                            let firstKey = obj.keys.first!
                            let value = obj[firstKey] as! [String : Any]
                            return ChoiceMenu(value)
                            
                        })
                    }
                    
                    
                    //checking version.
                    //Downloads all new assets if server version is greater than local version
                    
                    let serverVersion = json["version"] as! String
                    if serverVersion != APICall.shared.assetLocalVersion {
                        UserDefaults.standard.setValue(serverVersion, forKey: APICall.shared.assetVersionKey)

                        appDelegate.downloadNewAssets(completion: { (isFinish, progressValue) in
                            if isFinish {
                                block(menus)
                            } else {
                                //UserDefaults.standard.setValue("", forKey: APICall.shared.assetVersionKey)

                            }
                        })
                        
                    } else {
                        block(menus)
                    }
                    
                    
                }
            } else {
                block([])
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
    
    func get_emojisContext_json(block: @escaping ([String : [String : Any]])->Void) {
        APICall.shared.emojis_context_APICall { (json, isSuccess) in
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
    var iconName = ""
    var icon: UIImage?
    
    var heading = ""
    var choices = [CharacterChoice]()
    
    
    var selected = false
    
    init(_ json: [String : Any]) {
        title = (json["title"] as? String) ?? ""
//        iconName = APICall.shared.assetUrl + "/" + ((json["icon"] as? String) ?? "")
        iconName = (json["icon"] as? String) ?? ""

        heading = (json["heading"] as? String) ?? ""
        
        if let jsChoices = json["choices"] as? [String : Any] {
            for (key, obj) in jsChoices.enumerated() {
                print(key)
                print(obj)
                
                let charChoice = CharacterChoice(obj.value as! [String : Any])
                self.choices.append(charChoice)
            }
            
            self.choices.sort(by: { (ch1, ch2) -> Bool in
                return ch1.type == .square
            })
        }
    }
}

enum ChoiceType {
    case square, circle
}

class CharacterChoice {
    var choiceId = ""
    var options = [ChoiceOption]()
    var type = ChoiceType.square
    
    convenience init(_ json : [String : Any]) {
        self.init()
        
        choiceId = (json["choice_id"] as? String) ?? ""
        
        let typeValue = json["thumbnail_type"] as! String
        
        self.type = typeValue == "square" ? .square : .circle
        
        if let jsOptions = json["options"] as? [[String : [String : Any]]] {
            options = jsOptions.map({ obj -> ChoiceOption in
                let optionKey = obj.keys.first!
                let option = obj[optionKey]!
                return ChoiceOption(option, iconName: optionKey)
            })
        }
    }
}

class ChoiceOption {
    var name = ""
    var choices = [CharacterChoice] ()
    var iconName = ""
    var selected = false
    var hideHair = false
    
    var icon: UIImage?
    
    convenience init(_ json: [String : Any], iconName: String) {
        self.init()
       
        self.name = (json["name"] as? String) ?? ""
        self.iconName = iconName //+ ".png"
        self.hideHair = (json["hide_hair"] as? Bool) ?? false
        
        if let jsChoices = json["choices"] as? [String : Any] {
            for (key, obj) in jsChoices.enumerated() {
                print(key)
                print(obj)
                
                let charChoice = CharacterChoice(obj.value as! [String : Any])
                self.choices.append(charChoice)
            }

        }
        
    }
}

