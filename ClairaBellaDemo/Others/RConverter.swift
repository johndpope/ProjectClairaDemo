//
//  RawdataConverter.swift
//
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

class RConverter {
    
    class func date(_ timestamp: Any?) -> Date {
        if let any = timestamp {
            if let str = any as? NSString {
                return Date(timeIntervalSince1970: str.doubleValue)
            } else if let str = any as? NSNumber {
                return Date(timeIntervalSince1970: str.doubleValue)
            }
        }
        return Date()
    }
    
    class func integer(_ anything: Any?) -> Int {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.intValue
            } else if let str = any as? NSString {
                return str.integerValue
            }
        }
        return 0
        
    }
    
    class func double(_ anything: Any?) -> Double {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.doubleValue
            } else if let str = any as? NSString {
                return str.doubleValue
            }
        }
        return 0
        
    }
    
    class func float(_ anything: Any?) -> Float {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.floatValue
            } else if let str = any as? NSString {
                return str.floatValue
            }
        }
        return 0
        
    }
    
    class func string(_ anything: Any?) -> String {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.stringValue
            } else if let str = any as? String {
                return str
            }
        }
        return ""
        
    }
    
    class func optionalString(_ anything: Any?) -> String? {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.stringValue
            } else if let str = any as? String {
                return str
            }
        }
        return nil
        
    }
    
    class func boolean(_ anything: Any?) -> Bool {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }

}


