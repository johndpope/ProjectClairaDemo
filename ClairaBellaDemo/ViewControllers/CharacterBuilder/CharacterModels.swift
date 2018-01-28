//
//  CharacterModels.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 12/12/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation



private let nonPersnolizedEmojis = ["EJ001", "EJ002","EJ003","EJ004","EJ005","EJ006",
                                    "EJ007", "EJ008","EJ009","EJ010","EJ011","EJ012",
                                    "EJ013", "EJ014","EJ015","EJ016","EJ017","EJ018",
                                    "EJ019", "EJ020","EJ021","EJ022","EJ023","EJ024",
                                    "EJ025", "EJ026","EJ027","EJ028","EJ029","EJ030",
                                    "EJ031", "EJ032","EJ033","EJ034","EJ035","EJ036",
                                    "EJ037", "EJ038","EJ039","EJ040","EJ041","EJ042",
                                    "EJ043", "EJ044","EJ045","EJ046","EJ047","EJ048",
                                    "EJ049", "EJ050","EJ051","EJ052","EJ053","EJ054","EJ055",
                                    "EJ056", "EJ057","EJ058","EJ059","EJ060","EJ061", "EJ062"]

protocol CharacterType {
    var charHtml: String {get set}
}



class Emoji: CharacterType {
    var charHtml = ""
    var key: String = ""
    var characterCreatedDate = ""
    
    let filemanager = FileManager.default
    
    

    func getEmojiURL(char: Character)->URL {
        let isNonPersnolizedEmoji = nonPersnolizedEmojis.contains(self.key)
        
        let emojiFileNameWithDirectoryName = isNonPersnolizedEmoji ? "NonPersnolizeEmoji/\(self.key)" : (char.createdDate + "/" + self.key)
        
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(emojiFileNameWithDirectoryName)
        return url
    }
    
    func getSaveDirectoryURL(char: Character)->URL {
        let isNonPersnolizedEmoji = nonPersnolizedEmojis.contains(self.key)
        
        let directoryName = isNonPersnolizedEmoji ? "NonPersnolizeEmoji" : (char.createdDate)
        
        let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(directoryName)
        return url
    }

    
    class func isNonPersnolizedEmojiDownloaded()-> Bool {
        let filemanager = FileManager.default

        var result = false
        
        for item in nonPersnolizedEmojis {
            let emojiName = "NonPersnolizeEmoji/\(item)"
            let url = filemanager.containerURL(forSecurityApplicationGroupIdentifier: appGroupName)!.appendingPathComponent(emojiName)
            if filemanager.fileExists(atPath: url.path) {
                result = true
            }
        }
        
        return result
    }
    
    class var nonPersnolizedEmojiCounts: Int {
        return nonPersnolizedEmojis.count
    }
}

struct CharBackground {
    var icon = ""
    var image = ""
}



class Character: NSCopying, CharacterType, Equatable {
    
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
        return myCharacters.filter({$0.isMainChar}).first ?? myCharacters.first
    }
    
    static func ==(lhs: Character, rhs: Character)-> Bool {
        return lhs.createdDate == rhs.createdDate
    }
    
    //
}

