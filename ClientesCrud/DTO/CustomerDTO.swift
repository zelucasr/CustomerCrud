//
//  CustomerDTO.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import Foundation

struct CustomerDTO {
    var cpf: String = ""
    var name: String = ""
    var birthDate: Date = Date()
    var phone: String = ""
    //false: W / true: M
    var gender: Bool = false
}
