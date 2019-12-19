//
//  Environment.swift
//  ContactsApp
//
//  Created by Subhadeep Pal on 29/08/19.
//

import Foundation

public enum PlistKey {
    case hostname
    case serverProtocol
    case apiVersion
    
    func value() -> String {
        switch self {
        case .hostname:
            return "BASE_URL_HOSTNAME"
        case .serverProtocol:
            return "BASE_URL_PROTOCOL"
        case .apiVersion:
            return "API_VERSION"
        }
    }
}

public struct Environment {
    fileprivate var infoDict: [String: Any]  {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    public func configuration(_ key: PlistKey) -> String {
        return (infoDict[key.value()] as! String).replacingOccurrences(of: "\\", with: "")
    }
}
