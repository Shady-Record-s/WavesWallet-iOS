//
//  StartLeasingAmountView.swift
//  WavesWallet-iOS
//
//  Created by Pavel Gubin on 9/29/18.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import UIKit

private enum Constants {
    static let animationFrameDuration: TimeInterval = 0.3
    static let animationErrorLabelDuration: TimeInterval = 0.3
    static let borderRadius: CGFloat = 2
    static let borderWidth: CGFloat = 0.5
}

protocol AmountInputViewDelegate: AnyObject {
    func amountInputView(didChangeValue value: Money)
}

final class AmountInputView: UIView, NibOwnerLoadable {
    
    private var isShowInputScrollView = false
    private var isHiddenErrorLabel = true
    
    @IBOutlet private weak var labelAmountLocalizable: UILabel!
    @IBOutlet private weak var labelAmount: UILabel!
    @IBOutlet private weak var textFieldMoney: MoneyTextField!
    @IBOutlet private weak var scrollViewInput: InputScrollButtonsView!
    @IBOutlet private weak var viewTextField: UIView!
    @IBOutlet private weak var scrollViewInputHeight: NSLayoutConstraint!
    @IBOutlet private weak var labelError: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: AmountInputViewDelegate?
    var input:(() -> [Money])?

    var isBlockMode = false {
        didSet {
            updateViewStyle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelAmountLocalizable.text = Localizable.Waves.Startleasing.Label.amount
        viewTextField.addTableCellShadowStyle()
        scrollViewInput.inputDelegate = self
        textFieldMoney.moneyDelegate = self
        labelError.alpha = 0
   }
    
    func showErrorMessage(message: String, isShow: Bool) {
        if isShow {
            labelError.text = message
            
            if isHiddenErrorLabel {
                isHiddenErrorLabel = false
                UIView.animate(withDuration: Constants.animationErrorLabelDuration) {
                    self.labelError.alpha = 1
                }
            }
        }
        else {
            if !isHiddenErrorLabel {
                isHiddenErrorLabel = true
                
                UIView.animate(withDuration: Constants.animationErrorLabelDuration) {
                    self.labelError.alpha = 0
                }
            }
        }
    }
    
    func activateTextField() {
        textFieldMoney.becomeFirstResponder()
    }
    
    func setupRightLabelText(_ string: String) {
        labelAmount.text = string
    }
    
    func setupTitle(_ string: String) {
        labelAmountLocalizable.text = string
    }
    
    func setDecimals(_ decimals: Int, forceUpdateMoney: Bool) {
        textFieldMoney.setDecimals(decimals, forceUpdateMoney: forceUpdateMoney)
    }
    
    func setAmount(_ amount: Money) {
        
        if textFieldMoney.decimals == 0 {
            textFieldMoney.setDecimals(amount.decimals, forceUpdateMoney: false)
        }
        textFieldMoney.setValue(value: amount)
    }
    
    func clearMoney() {
        textFieldMoney.clear()
    }
    
    func hideAnimation() {
        activityIndicator.stopAnimating()
        textFieldMoney.isHidden = false
    }
    
    func showAnimation() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        textFieldMoney.isHidden = true
    }
}

//MARK: - UI
private extension AmountInputView {
    func updateViewStyle() {
        if isBlockMode {
            textFieldMoney.isUserInteractionEnabled = false
            viewTextField.layer.removeShadow()
            viewTextField.backgroundColor = .clear
            viewTextField.layer.cornerRadius = Constants.borderRadius
            viewTextField.layer.borderWidth = Constants.borderWidth
            viewTextField.layer.borderColor = UIColor.overlayDark.cgColor
        }
        else {
            textFieldMoney.isUserInteractionEnabled = true
            viewTextField.backgroundColor = .white
            viewTextField.layer.cornerRadius = 0
            viewTextField.layer.borderWidth = 0
            viewTextField.layer.borderColor = nil
            viewTextField.addTableCellShadowStyle()
        }
    }
}

//MARK: - MoneyTextFieldDelegate
extension AmountInputView: MoneyTextFieldDelegate {
    
    func moneyTextField(_ textField: MoneyTextField, didChangeValue value: Money) {
        delegate?.amountInputView(didChangeValue: value)
        updateViewHeight(inputValue: value, animation: true)
    }
}

//MARK: - ViewConfiguration
extension AmountInputView: ViewConfiguration {
    
    func update(with input: [String]) {
        isShowInputScrollView = input.count > 0
        scrollViewInput.update(with: input)
        updateViewHeight(inputValue: textFieldMoney.value, animation: false)
    }
}


//MARK: - InputScrollButtonsViewDelegate
extension AmountInputView: InputScrollButtonsViewDelegate {

    func inputScrollButtonsViewDidTapAt(index: Int) {
        
        if let values = input {
            let value = values()[index]
            textFieldMoney.setValue(value: value)
            delegate?.amountInputView(didChangeValue: value)
            updateViewHeight(inputValue: value, animation: true)
        }
    }
}


//MARK: - Change frame
private extension AmountInputView {
    
    func updateViewHeight(inputValue: Money, animation: Bool) {
        
        if isShowInputScrollView {
            if inputValue.isZero {
                showInputScrollView(animation: animation)
            }
            else {
                hideInputScrollView(animation: animation)
            }
        }
        else {
            hideInputScrollView(animation: animation)
        }
    }
    
    func showInputScrollView(animation: Bool) {
        
        let height = scrollViewInput.frame.origin.y + scrollViewInput.frame.size.height
        guard heightConstraint.constant != height else { return }
        
        heightConstraint.constant = height
        updateWithAnimationIfNeed(animation: animation, isShowInputScrollView: true)
    }
    
    func hideInputScrollView(animation: Bool) {
        
        let height = viewTextField.frame.origin.y + viewTextField.frame.size.height
        guard heightConstraint.constant != height else { return }
        
        heightConstraint.constant = height
        updateWithAnimationIfNeed(animation: animation, isShowInputScrollView: false)
    }
    
    func updateWithAnimationIfNeed(animation: Bool, isShowInputScrollView: Bool) {
        if animation {
            UIView.animate(withDuration: Constants.animationFrameDuration) {
                self.firstAvailableViewController().view.layoutIfNeeded()
                self.scrollViewInput.alpha = isShowInputScrollView ? 1 : 0
            }
        }
        else {
            scrollViewInput.alpha = isShowInputScrollView ? 1 : 0
        }
    }
    
    var heightConstraint: NSLayoutConstraint {
        
        if let constraint = constraints.first(where: {$0.firstAttribute == .height}) {
            return constraint
        }
        return NSLayoutConstraint()
    }
}
