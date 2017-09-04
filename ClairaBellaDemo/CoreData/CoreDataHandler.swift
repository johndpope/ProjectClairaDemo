//
//  File.swift
//  ClairaBellaDemo
//
//  Created by Vikash Kumar on 03/09/17.
//  Copyright © 2017 Vikash Kumar. All rights reserved.
//

import Foundation
import CoreData


class CDHelper {
    static let shared = CDHelper()
    
    private init() {
        //
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
