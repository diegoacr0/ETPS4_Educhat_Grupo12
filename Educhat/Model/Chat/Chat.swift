//
//  Chat.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 4/12/23.
//

import Foundation

class Chat: Identifiable, ObservableObject{

    private var _documentId: String = ""
    private var _fromId: String = ""
    private var _toId: String = ""
    private var _text: String = ""
    
    var documentId: String{
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
}
