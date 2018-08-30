//
//  ErrorHandler.swift
//  KoreaLover
//
//  Created by 김승진 on 2018. 8. 31..
//  Copyright © 2018년 김승진. All rights reserved.
//

import Foundation

enum AuthSignIn: Error {
    case InvalidEmail
    case UserDisabled
    case WrongPassword
}
