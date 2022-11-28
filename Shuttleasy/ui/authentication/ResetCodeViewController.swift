
import UIKit
import Combine
import SnapKit

class ResetCodeViewController : BaseViewController {
  
   private lazy var logoContainer : UIView = {
        let view = UILabel()
        view.backgroundColor = primaryContainer
        let logo = resImage(name: "logo")
        view.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(92)
            make.width.lessThanOrEqualTo(56)
            make.top.equalToSuperview().offset(64)
            make.bottom.equalToSuperview().offset(-16)
        }

        return view
    }()
  
  
    lazy var resetCodeInputSection : UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = backgroundColor
        stack.axis = .vertical
        stack.spacing = 36
        let resetCodeSection: UIView = textInputSection(
            title: "Reset Code",
            inputHint: "Code...",
            keyboardInputType: .emailAddress,
            textContentType: .emailAddress
        )

        stack.addArrangedSubview(resetCodeSection)
        resetCodeSection.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        return stack
    }()
  
  
    lazy var resetButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Send Code", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
           self.sendResetCode()
        }
        return button
    }()
  
     lazy var sendCodeAgainText : UILabel = {
        let label = UILabel()
        label.attributedText = NSMutableAttributedString()
            .span("Did not receive any code ? ",font: BodySmallFont(), foregroundColor: onBackgroundColor)
            .span("Send Again.", font : BodySmallFont(), foregroundColor: primaryColor)
        label.textAlignment = .center
        label.breakLineFromEndIfNeeded()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ResetCodeViewController.sendResetCode))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        
        return label
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.addSubview(logoContainer)
        logoContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
     
        view.addSubview(resetCodeInputSection)
        resetCodeInputSection.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
        }
      
      
      view.addSubview(sendCodeAgainText)
        sendCodeAgainText.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-32)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualTo(sendCodeAgainText.snp.bottom).offset(-24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(largeButtonHeight)
            make.centerX.equalToSuperview()
        }
   }
  
   @objc
    func sendResetCode() {
        // TODO 
    }
  
}