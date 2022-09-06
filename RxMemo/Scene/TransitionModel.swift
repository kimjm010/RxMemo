//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation


enum TransitionStyle {
    case root
    case push
    case modal
}


enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
