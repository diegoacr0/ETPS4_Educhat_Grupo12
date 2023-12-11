//
//  RecentMessage.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 5/12/23.
//

import Foundation
import Firebase

class RecentMessage: Identifiable{
    private var _documentId: String = ""
    private var _fromId: String = ""
    private var _toId: String = ""
    private var _text: String = ""
    private var _email: String = ""
    private var _profileImageUrl: String = ""
    private var _timestamp: String = ""
    
    var username: String {
        email.components(separatedBy: "@") .first ?? email
    }
    
    func timeAgo(fecha: Date) -> String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: fecha, relativeTo: Date())
    }
    
    var profileImageUrl: String{
        get{
            return _profileImageUrl
        }
        set{
            _profileImageUrl = newValue
        }
    }
    
    var documentId: String {
        get{
            return _documentId
        }
        set{
            _documentId = newValue
        }
    }
    
    var fromId: String{
        get{
            return _fromId
        }
        set{
            _fromId = newValue
        }
    }
    
    var toId: String{
        get{
            return _toId
        }
        set{
            _toId = newValue
        }
    }
    
    var text: String{
        get{
            return _text
        }
        set{
            _text = newValue
        }
    }
    
    var email: String{
        get{
            return _email
        }
        set{
            _email = newValue
        }
    }
    
    var timestamp: String{
        get{
            return _timestamp
        }
        set{
            _timestamp = newValue
        }
    }
}
