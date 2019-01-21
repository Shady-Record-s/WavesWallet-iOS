//
//  SetAssetScriptTransaction.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 22/01/2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation
import RealmSwift

final class SetAssetScriptTransaction: Transaction {

    
    @objc dynamic var script: String? = nil
    @objc dynamic var assetId: String = ""
}
