
import UIKit
import Combine
import SnapKit

class ResetCodeViewController : BaseViewController {
  
    private let viewModel : ResetCodeViewModel = Injector.shared.injectResetCodeViewModel()
    private var resetCodeSentObserver : AnyCancellable? = nil
    private var resetCodeVerifiedObserver : AnyCancellable? = nil
    private let userEmail : String

    init(userEmail: String){
        self.userEmail  = userEmail
        super.init(nibName: nil, bundle: nil)
    }
       
    required init(coder : NSCoder){
        fatalError()
    }

    private lazy var logoContainer : UIView = {
        let view = UILabel()
        view.backgroundColor = primaryContainer
        let logo = resImageView(name: "logo")
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
  
  
   private lazy var resetCodeInputSection : UIStackView = {
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


         let label = LabelSmall(
            text: "Enter the reset code we have send to your email",
            color : onBackgroundColor.withAlphaComponent(0.5)
        )
        
        label.textAlignment = .center


        stack.addArrangedSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        
        return stack
    }()

    private func getResetCodeInput() -> UITextField {
        return resetCodeInputSection.arrangedSubviews[0].subviews[1] as! UITextField
    }

    lazy var resetButton : UIButton = {
        let button = LargeButton(titleOnNormalState: "Confirm Code", backgroundColor: primaryColor, titleColorOnNormalState: onPrimaryColor)
        button.setOnClickListener {
            self.onResetCodeSendClicked()
        }
        return button
    }()
    
    func onResetCodeSendClicked() {
        let resetCode = getResetCodeInput().text ?? ""
        guard  resetCode.isEmpty.not() else {
            showErrorSnackbar(message: "Reset code is required")
            return
        }

        viewModel.sendResetCode(email: userEmail, code: resetCode)
    }

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
    
    @objc
    func sendResetCode() {
         viewModel.sendResetCodeTo(email: userEmail)
    }

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
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
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
        
        subscribeObservers()
   }

   func subscribeObservers() {
       resetCodeVerifiedObserver =  viewModel.resetCodeResult
           .receive(on: DispatchQueue.main)
           .sink { [weak self] completion in
               switch completion {
                case .finished:
                    break 
                case .failure(let error):
                    self?.showErrorSnackbar(message: error.localizedDescription)
            }
           } receiveValue: { [weak self] result in
                result.onSuccess { [weak self] data in 
                    let isAccepted = data.data
                    if (isAccepted) {
                        self?.navigateToResetPasswordPage()
                    } else {
                        self?.showErrorSnackbar(message: "Reset code is not accepted")
                    }
                }.onError { [weak self] errorMessage in
                    self?.showErrorSnackbar(message: errorMessage)
                }
           } 

        resetCodeSentObserver = viewModel.resetCodeSendResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break 
                    case .failure(let error):
                        self?.showErrorSnackbar(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] result in
                result.onSuccess { [weak self] data in 
                    let isSent = data.data
                    if (isSent) {
                        self?.showInformationSnackbar(message: "Reset code sent")
                    } else {
                        self?.showErrorSnackbar(message: "Something went wrong")
                    }
                }.onError { [weak self] errorMessage in
                    self?.showErrorSnackbar(message: errorMessage)
                }
            }
   }

   func navigateToResetPasswordPage() {
       Navigator.shared.navigateToResetPassword(from: self,userEmail: userEmail)
   }
}
