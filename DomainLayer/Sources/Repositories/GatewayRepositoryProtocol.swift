//
//  GatewayRepositoryProtocol.swift
//  InternalDomainLayer
//
//  Created by Pavel Gubin on 22.06.2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift

public protocol GatewayRepositoryProtocol {
    
    func initWithdrawProcess(address: String, asset: DomainLayer.DTO.Asset) -> Observable<DomainLayer.DTO.Gateway.InitWithdrawProcess>
    func initDepositProcess(address: String, asset: DomainLayer.DTO.Asset) -> Observable<DomainLayer.DTO.Gateway.InitDepositProcess>

    func sendWithdraw() -> Observable<Bool>
    
}
