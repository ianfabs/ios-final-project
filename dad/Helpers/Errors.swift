//
//  Errors.swift
//  dad
//
//  Created by Fabricatore, Ian T on 3/11/20.
//  Copyright © 2020 Fabricatore, Ian T. All rights reserved.
//

import Foundation

enum AppError: Error {
    case General, Unknown, TooManyTasks, NoTasks
}

enum SceneError: Error {
    case View, Controller, Segue
}

enum SQLError: Error {
    case ResultEmpty, Unknown, DecodeFailed
}
