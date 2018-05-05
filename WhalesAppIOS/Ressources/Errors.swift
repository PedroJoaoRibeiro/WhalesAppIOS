//
//  Errors.swift
//  WhalesAppIOS
//
//  Created by Pedro Ribeiro on 05/05/2018.
//  Copyright © 2018 Pedro Ribeiro. All rights reserved.
//

import Foundation

enum MyErrors: Error {
    case openDB(msg: String)
    case creatingTable(msg: String)
}
