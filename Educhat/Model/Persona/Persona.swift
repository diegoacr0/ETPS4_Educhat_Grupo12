//
//  Persona.swift
//  Educhat
//
//  Created by Diego Alejandro Ceron on 26/11/23.
//

import Foundation
import SwiftUI

class Persona: Identifiable, ObservableObject{
    private var _image: UIImage?
    private var _image1: UIImage?
    private var _urlimage: String = ""
    private var _nombre: String = ""
    private var _email: String = ""
    private var _password: String = ""
    private var _uid: String = ""
    private var _urlimage1: String = ""
    
    var image1: UIImage?{
            get {
                return _image1
            }
            set {
                _image1 = newValue
            }
    }
    
    var urlimage1: String{
        get{
            return _urlimage1
        }
        set{
            _urlimage1 = newValue
        }
    }
    
    var uid: String{
        get{
            return _uid
        }
        set{
            _uid = newValue
        }
    }
 
    var urlimage: String{
        get{
            return _urlimage
        }
        set{
            _urlimage = newValue
        }
    }
    
    var passwo: String{
        get{
            return _password
        }
        set{
            _password = newValue
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
    
    var image: UIImage?{
            get {
                return _image
            }
            set {
                _image = newValue
            }
    }
    var nombre: String {
            get {
                return _nombre
            }
            set {
                _nombre = newValue
            }
    }
}
