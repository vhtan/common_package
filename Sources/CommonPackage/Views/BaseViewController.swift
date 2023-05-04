//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import RxSwift

public protocol BindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

public extension BindableType where Self: UIViewController {
    mutating func bindVM(to model: Self.ViewModelType) {
        viewModel = model
    }
}

open class BaseViewController<T: GenericViewModel> : CommonViewController, BindableType {
    public var viewModel: T!
    public let contentView = BaseContentView()
    
    open override func loadView() {
        super.loadView()
        makeContent()
    }
    
    private func makeContent() {
        navigationController?.navigationBar.isHidden = true
        contentView.backgroundColor = UIColor.clear
        
        view.addSubview(contentView)
        contentView.snp.remakeConstraints { (marker) in
            marker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}

open class CommonViewController: UIViewController {
    
    deinit {
        log.info("deinit \(String(describing: self))")
        NotificationCenter.default.removeObserver(self)
    }
    
    open var safeAreaInsets: UIEdgeInsets? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets
        }
    }
    
    open lazy var screenWidth: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    
    open lazy var screenHeight: CGFloat = {
        return UIScreen.main.bounds.height
    }()
    
    open var disposeBag = DisposeBag()
    
    // MARK: - Instantiate the view controller with proper with class from storyboard
    public class func instantiate() -> Self {
        let vc: Self = self.instantiateFromStoryboard()
        vc.self.modalPresentationStyle = .fullScreen
        
        return vc
    }
    
    private class func instantiateFromStoryboard<T>() -> T {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: self.storyboardName(), bundle: Bundle(for: self))
        let vc = storyboard.instantiateViewController(withIdentifier: className) as! T
        
        return vc
    }
    
    open class func storyboardName() -> String {
        return "Main"
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        setupUI()
        bindViewModel()
        localize()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        log.info("viewDidAppear \(String(describing: self))")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isHideNavigationBar, animated: true)
    }
    
    open var isHideNavigationBar: Bool {
        return true
    }
    
    open func localize() { }

    open func bindViewModel() {
        //Subsclass implement
    }
    
    open func setupUI() {
        //Subsclass implement
    }
}

public class BaseContentView : UIView, SpinableView {
    
    public var indicator: IndicatorView = {
        let indicatorView = IndicatorView(frame: .zero)
        return indicatorView
    }()
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for case let view in self.subviews {
            if (!view.isHidden && view.alpha > 0 && view.isUserInteractionEnabled && view.point(inside: self.convert(point, to: view), with: event)) {
                return true
            }
        }
        return false
    }
}
