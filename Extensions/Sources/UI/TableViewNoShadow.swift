//
//  TableViewNoShadow.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 4/29/19.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import UIKit

public final class TableViewNoShadow: UITableView {
    
    override public func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if "\(type(of: subview))" == "UIShadowView" {
            subview.removeFromSuperview()
        }
    }
}
