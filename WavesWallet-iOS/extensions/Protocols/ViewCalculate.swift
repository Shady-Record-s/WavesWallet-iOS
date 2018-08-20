//
//  ViewCalculated.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 25.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import UIKit

protocol ViewCalculateHeight {
    associatedtype Model
    static func viewHeight(model: Model) -> CGFloat
}

extension ViewCalculateHeight where Model == Void {
    static func viewHeight() -> CGFloat {
        return viewHeight(model: ())
    }
}
