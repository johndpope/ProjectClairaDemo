//
//  CharacterModels.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 12/12/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation


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
        return myCharacters.filter({$0.isMainChar}).first ?? myCharacters.first
    }
    
    
    //
}

