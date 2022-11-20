import Foundation
import UIKit
import SnapKit

public protocol SnackBarAction {
    func setAction(with title: String, action: (() -> Void)?) -> SnackBarPresentable
}

public protocol SnackBarPresentable {
    
    func show()
    func dismiss()
}

open class SnackBar: UIView, SnackBarAction, SnackBarPresentable {
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView(
            arrangedSubviews: [messageLabel])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 10
        return mainStackView
    }()
    
    private lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.numberOfLines = Int(style.maxNumberOfLines)
        messageLabel.font = style.font
        messageLabel.textColor = style.textColor
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.8
        return messageLabel
    }()
    
    private lazy var actionButton: UIButton = {
        let actionButton = UIButton(type: .system)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.setTitleColor(
            style.actionTextColor
                .withAlphaComponent(style.actionTextColorAlpha),
            for: .normal)
        actionButton.titleLabel?.font = style.actionFont
        return actionButton
    }()
    
    open var style: SnackBarStyle  = SnackBarStyle()
   
    private let contextView: UIView
    private let message: String
    private let duration: Duration
    private var dismissTimer: Timer?
    
    required public init(contextView: UIView, message: String, duration: Duration) {
        self.contextView = contextView
        self.message = message
        self.duration = duration
        super.init(frame: .zero)
        self.backgroundColor = style.background
        self.layer.cornerRadius = 5
        setupView()
        setupSwipe()
        self.messageLabel.text = message
    }
    
    
    required public init( contextView : UIView, message : String, duration : Duration, style : SnackBarStyle) {
        self.contextView = contextView
        self.message = message
        self.duration = duration
        super.init(frame: .zero)
        self.style = style
        self.backgroundColor = style.background
        self.layer.cornerRadius = 5
        setupView()
        setupSwipe()
        self.messageLabel.text = message
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    private func constraintSuperView(with view: UIView) {
    
        view.setupSubview(self) {
            
            $0.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(200)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(style.padding)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-style.padding)
            }
        }
        
    }
    private func setupView() {
        
        self.setupSubview(mainStackView) {
            
            $0.makeConstraints {
                $0.bottom.trailing.equalTo(self).offset(-style.inViewPadding)
                $0.top.leading.equalTo(self).offset(style.inViewPadding)
            }
        }
    }
    
    private func setupSwipe() {
        
        self.addSwipeGestureAllDirection(action: #selector(self.swipeAction(_:)))

    }
    
    @objc private func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        self.dismiss()
        
    }
    
    private static func removeOldViews(form view: UIView) {
        
        view.subviews
            .filter({ $0 is Self })
            .forEach({ $0.removeFromSuperview() })

    }
    
    private func animation(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        superview?.layoutIfNeeded()
            
            self.snp.updateConstraints {
                $0.bottom.equalTo(self.contextView.safeAreaLayoutGuide).offset(offset)
            }
            UIView.animate(
                withDuration: 1.2,
                delay: 0.0, usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0.7, options: .curveEaseOut,
                animations: {
                    self.superview?.layoutIfNeeded()
            }, completion: completion)
    }
    
    
    private func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    // MARK: - Public Methods
    
    public static func make(in view: UIView, message: String, duration: Duration) -> Self {
        removeOldViews(form: view)
        return Self.init(contextView: view, message: message, duration: duration)
    }
    
    public static func make(in view: UIView, message: String, duration: Duration, styleBuilder : () -> SnackBarStyle ) -> Self {
        removeOldViews(form: view)
        return Self.init(contextView: view, message: message, duration: duration, style:  styleBuilder())
    }
    
    public func setAction(with title: String, action: (() -> Void)? = nil) -> SnackBarPresentable {
        mainStackView.addArrangedSubview(actionButton)
        actionButton.setTitle(title, for: .normal)
        actionButton.actionHandler(controlEvents: .touchUpInside) { [weak self] in
            self?.dismiss()
            action?()
        }
        
        return self
    }
    
    @objc public func show() {
        constraintSuperView(with: contextView)
        animation(with: -CGFloat(style.padding)) { _ in
            
            if self.duration != .infinite {
            self.dismissTimer = Timer.init(
                timeInterval: TimeInterval(self.duration.value),
                target: self, selector: #selector(self.dismiss),
                userInfo: nil, repeats: false)
            RunLoop.main.add(self.dismissTimer!, forMode: .common)
            }
        }
        
    }
    
    @objc public func dismiss() {

        invalidDismissTimer()
        
        animation(with: 200, completion: { _ in
            self.removeFromSuperview()
        })
    }
}


extension UIView {
    
    func setupSubview(_ subview: UIView, setup: (ConstraintViewDSL) -> Void) {
        self.addSubview(subview)
        setup(subview.snp)
    }
}

extension UIView {
    
    func addSwipeGestureAllDirection(action: Selector) {
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: action)
        swipeLeft.direction = .left
        swipeLeft.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: action)
        swipeRight.direction = .right
        swipeRight.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: action)
        swipeUp.direction = .up
        swipeUp.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: action)
        swipeDown.direction = .down
        swipeDown.numberOfTouchesRequired = 1
        self.addGestureRecognizer(swipeDown)
    }
}


public struct SnackBarStyle {
    public init() { }
    // Container
    public var background: UIColor = .lightGray
    var padding = 5
    var inViewPadding = 20
    // Label
    public var textColor: UIColor = .black
    public var font: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 14))
    var maxNumberOfLines: UInt = 2
    // Action
    public var actionTextColorAlpha: CGFloat = 0.5
    public var actionFont: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 17))
    public var actionTextColor: UIColor = .red
}

extension UIButton {
    struct Trager { static var action :(() -> Void)? }
    private func actionHandler(action:(() -> Void)? = nil) {
        if action != nil {
            Trager.action = action
            
        } else {
            Trager.action?()
            
        }
    }
    @objc private func triggerActionHandler() {
        self.actionHandler()
    }
    func actionHandler(controlEvents control: UIControl.Event, ForAction action: @escaping () -> Void) {
        self.actionHandler(action: action)
        self.addTarget(self, action: #selector(triggerActionHandler), for: control)
    }
}

extension SnackBar {
    
    public enum Duration: Equatable {
        case lengthLong
        case lengthShort
        case infinite
        case custom(CGFloat)
        
        var value: CGFloat {
            
            switch self {
            
            case .lengthLong:
                return 3.5
            case .lengthShort:
                return 2
            case .infinite:
                return -1
            case .custom(let duration):
                return duration
            }
        }
    }
}
