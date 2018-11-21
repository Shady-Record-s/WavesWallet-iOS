//
//  SupportViewController.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 02/10/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import UIKit
import Crashlytics
import RxSwift

protocol SupportViewControllerDelegate: AnyObject {
    func closeSupportView(isTestNet: Bool)
}

final class SupportViewController: UIViewController {
    @IBOutlet private var versionLabel: UILabel!
    @IBOutlet private var buildVersionLabel: UILabel!
    @IBOutlet private var testNetSwitch: UISwitch!
    weak var delegate: SupportViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let on = Environments.isTestNet
        testNetSwitch.setOn(on, animated: true)
        versionLabel.text = version()
        buildVersionLabel.text = buildVersion()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.topbarLogout.image, style: .done, target: self, action: #selector(actionBack))
    }

    @IBAction private func actionBack() {
        delegate?.closeSupportView(isTestNet: testNetSwitch.isOn)
    }

    @IBAction func actionTestNetSwitch(sender: Any) {
        
    }

    @IBAction func actionCrash(_ sender: Any) {
        Crashlytics.sharedInstance().crash()
    }

    @IBAction func actionClean(_ sender: Any) {
        let auth = FactoryInteractors.instance.authorization
        auth.authorizedWallet().flatMap { (wallet) -> Observable<Bool> in
            let realm = try? WalletRealmFactory.realm(accountAddress: wallet.address)
            try? realm?.write {
                realm?.deleteAll()
            }
            return Observable.just(true)
        }.subscribe().dispose()
    }

    @IBAction func actionShowErrorSnack(_ sender: Any) {
        let error = SweetSnack.init(title: "Какая-нибудь лайтовая ошибка",
                                    backgroundColor: UIColor.error400.withAlphaComponent(0.94),
                                    behaviorDismiss: .popToLast,
                                    subtitle: nil,
                                    icon: Images.refresh18White.image,
                                    isEnabledUserHidden: false,
                                    action: nil)
        SweetSnackbar.shared.showSnack(error, on: self)
    }

    @IBAction func actionShowWithoutInternetSnack(_ sender: Any) {
        let error = SweetSnack.init(title: "No connection to the Internet",
                                    backgroundColor: UIColor.disabled666.withAlphaComponent(0.74),
                                    behaviorDismiss: .popToLast,
                                    subtitle: nil,
                                    icon: Images.refresh18White.image,
                                    isEnabledUserHidden: false,
                                    action: nil)
        SweetSnackbar.shared.showSnack(error, on: self)
    }

    @IBAction func actionShowSuccessSnack(_ sender: Any) {
        let error = SweetSnack.init(title: "Успешный вход/успешная операция",
                                    backgroundColor: UIColor.success400.withAlphaComponent(0.94),
                                    behaviorDismiss: .popToLastWihDuration(1),
                                    subtitle: nil,
                                    icon: nil,
                                    isEnabledUserHidden: true,
                                    action: nil)
        SweetSnackbar.shared.showSnack(error, on: self)
    }

    @IBAction func actionShowSeedSnack(_ sender: Any) {
        let error = SweetSnack.init(title: "Save your backup phrase (SEED)",
                                    backgroundColor: UIColor.error400.withAlphaComponent(0.94),
                                    behaviorDismiss: .never,
                                    subtitle: "Store your SEED safely, it is the only way to restore your wallet Store your SEED safely, it is the only way to restore your wallet",
                                    icon: Images.warning18White.image,
                                    isEnabledUserHidden: true,
                                    action: nil)
        SweetSnackbar.shared.showSnack(error, on: self)
    }

    private func version() -> String {
        let dictionary = Bundle.main.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String
        return version ?? ""
    }

    private func buildVersion() -> String {
        let dictionary = Bundle.main.infoDictionary
        let build = dictionary?["CFBundleVersion"] as? String
        return build ?? ""
    }
}


//
//S
