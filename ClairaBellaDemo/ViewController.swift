//
//  ViewController.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 17/08/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import UIKit
let webroot = "http://34.252.124.216/midnight/system/asset_library/character"
class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!

    var chartersChoice = [String : String]()
    var part_mapJson = [String : [String : Any]]()
    var parts = [String : [String : [String : Any]]]()
    var partsMeta = [String : Any]()
    var contextJson = [String : Any]()
    var wantedContext = "CX001"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showImageInWebView()
        self.getCharters()
        self.get_Context_Data()
        let url = URL(string: "http://45.79.169.241/svgdemo/api_tester.php")!
        let urlrequst = URLRequest(url: url)
        //webView.loadRequest(urlrequst)
    }


    func showImageInWebView() {
        if let filePath = Bundle.main.path(forResource: "BP001_BT001_OA011_BV008", ofType: "svg") {
            let htmlString = "<html><body><img src=\"file://\(filePath)\" width=\"150\" height=\"150\"></body></html>"
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
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
        
        var fileWidth = "0"
        var fileHeight = "0"
        var fileJoints: [String : [String : String]] = [:]
        
        if bodyPart == "top_layer" {
            print("got top_layer")
        }

        if let fileMeta = self.partsMeta[fileName] {
            //fileWidth = fileMeta["width"]
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
                                "x" : "", "y" : ""]
        
        }
        
        print(svgDataDic)
        
        var contextWidth = "0"
        var contextHeight = "0"
        var contextPoseData = [String : [String : Any]]()
        var contextPositionX = ""
        var contextPositionY = ""
       
        if let metaData = contextJson["meta_data"] as? [String : String] {
            contextWidth = metaData["width"] ?? "0"
            contextHeight = metaData["height"] ?? "0"
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
        print(contextPoseData)

     contextPoseData.forEach { (partName, locations) in
        if let dic2 = svgDataDic[partName] {
            let mergedic = self.merge(dic1: locations, dic2: dic2)
            //print(mergedic)
            contextPoseData[partName] = mergedic
        }
        }
        print("=========================")

        print(contextPoseData)
        
        let orderArr = ["torso_bottom",
                        "torso_top",
                        "top_layer",
                        "expression" ,
                        "right_upper_arm",
                        "left_upper_arm",
                        "right_upper_leg",
                        "left_upper_leg" ,
                        "right_lower_arm",
                        "left_lower_arm",
                        "right_lower_leg",
                        "left_lower_leg" ,
                        "eyes" ,
                        "eye_wear" ,
                        "head_wear" ,
                        "hair_style" ,
                        "left_hand" ,
                        "right_hand" ,
                        "right_boot_leg" ,
                        "left_boot_leg" ,
                        "right_foot" ,
                        "left_foot"
        ]
        var cpd = [String : [String : Any]]()

        var firstPartKey = orderArr.first!

        var firstPart: [String : Any] = contextPoseData[firstPartKey]!
        
//        contextPoseData.forEach { (key, partData) in
//            firstPart = partData
//            firstPartKey = key
//            return
//        }
        
        let specifiedCood = ["x" : contextPositionX, "y" : contextPositionY]
        let fp_width = firstPart["width"] as! String
        let fp_height = firstPart["height"] as! String
        let fp_scale = firstPart["scale"] as! String
        let w = Double(fp_width)!
        let h = Double(fp_height)!
        let s = Double(fp_scale)!
        
        let centralShift  = getCentralObjectCoords(coord: specifiedCood, width: w * s , height: h * s)
        
        contextPoseData[firstPartKey]?["x"] = centralShift["x"]
        contextPoseData[firstPartKey]?["y"] = centralShift["y"]
        orderArr.forEach { parentName in
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
            
            if parentName == "torso_top" {
                print("abc")
            }
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
                        
                        if childName == "torso_top" {
                            print("abc")
                        }
                        
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
//        contextPoseData.forEach { (parentName, parentData) in
//            
//        }
        
        NSLog("%@", contextPoseData)


        generateHTLM(for: contextPoseData)

    }
    
    func getJointGlobal(objGlobal: [String : Double], jointInternal : [String : Double], angle: Double)-> [String : Double] {
        let transformCoord = transformCoordWithRotation(jointInternal,  angle)
        let tcx = transformCoord["x"]!
        let tcy = transformCoord["y"]!
        let ogx = objGlobal["x"]!
        let ogy = objGlobal["y"]!
        
        let coord = ["x" : ogx + tcx, "y" : ogy + tcy]
        return coord
    }
    
    func getObjectGlobal(_ jointGlobal : [String : Double], _ jointInternal: [String : Double], _ angle: Double)-> [String : Double] {
        let transformCoords = transformCoordWithRotation(jointInternal, angle)
        let tcx = transformCoords["x"]!
        let tcy = transformCoords["y"]!
        let jgx = jointGlobal["x"]!
        let jgy = jointGlobal["y"]!
        
        let coord = ["x" : jgx - tcx, "y" : jgy - tcy]
        return coord
    }
    
    func transformCoordWithRotation(_ jointInternal: [String : Double], _ angle: Double)-> [String : Double] {
        let x = jointInternal["x"]!
        let y = jointInternal["y"]!
        let a = 0 - (angle * Double.pi / 180.0)
        let sin_a = sin(a)
        let cos_a = cos(a)
        let coord =  ["x" : y * sin_a + x * cos_a, "y" : y * cos_a - x * sin_a]
        return coord
    }
    
    func getCentralObjectCoords(coord: [String : String], width: Double, height: Double)-> [String : String] {
        let cx = Double(coord["x"]!)!
        let cy = Double(coord["y"]!)!
        return ["x" : "\(cx - (width/2))", "y" : "\(cy - (height/2))"]
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
    
    func getAttributes(attributeInfo: [String : String])-> String {
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
    
    
    func generateHTLM(for poseData: [String : [String : Any]]) {
        let htmlHeadStyle = "<!DOCTYPE html><html><head><title>test</title><style type=\"text/css\">*{margin:0;pading:0;border:0;} html, body{height:100%;} body{background-color: transparent !important;} div#canvas{position: relative;margin:0 auto;width:500px;height:800px;border:1px solid lightpink;overflow: hidden;} object{position: absolute;width: 100%;transform-origin: top left;}</style></head>"
        
        if let htmlFilePath = Bundle.main.path(forResource: "result", ofType: "html") {
             let fileURl = URL(fileURLWithPath: htmlFilePath)
            
        }
        
        var htmlBody = "<body><div id=\"canvas\">"
        poseData.forEach { (bodyPart, data) in
            if let _ = data["x"] as? String, let _ = data["y"] as? String {
                let fileNameWithExt = data["file"] as! String
                let fileName = fileNameWithExt.components(separatedBy: ".").first!
                let attributes = data["param"] as! String
                if let filePath = Bundle.main.path(forResource: fileName, ofType: "svg") {
                    if fileNameWithExt == "HS001.svg" {
                        
                    }
                    //htmlBody += "<img src=\"file://\(filePath)\" style=\"\(getFileStyle(data: data))\">"
                     htmlBody += "<object id=\"\(bodyPart)\" type=\"image/svg+xml\" name=\"\(bodyPart)\" data=\"\(webroot)/\(fileNameWithExt)?\(attributes)\" style=\"\(getFileStyle(data: data))\"></object>"

                }
            }
        }
        htmlBody += "</div></body></html>"
        let completeHtml = htmlHeadStyle + htmlBody
        webView.loadHTMLString(completeHtml, baseURL: nil)

        //
    }
    
    
    func getFileStyle(data: [String : Any])-> String {
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

//  htmlBody += "<object id=\"\(bodyPart)\" type=\"image/svg+xml\" name=\"\(bodyPart)\" >"




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