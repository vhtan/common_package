//
//  File.swift
//  
//
//  Created by Tan Vo on 05/05/2023.
//

import UIKit
import RxSwift

public class SceneCoordinator: SceneCoordinatorType {
    
    private var window: UIWindow
    public weak var currentViewController: UIViewController?
    
    public required init(_ window: UIWindow) {
        self.window = window
        currentViewController = window.rootViewController
    }
    
    private static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.last!
        } else {
            return viewController
        }
    }
    
    public func updateCurrentToVC(_ viewController: UIViewController) {
        self.currentViewController = SceneCoordinator.actualViewController(for: viewController)
    }
    
    public func transition(to scene: Scene, type: SceneTransition, animated: Bool, completion: TransitionCompletion?) {
        transition(to: scene.createViewController(), type: type, animated, completion: completion)
    }
    
    private func transition(to vc: UIViewController, type: SceneTransition, _ animated: Bool, completion: TransitionCompletion?) {
        switch type {
            
        case .root:
            if let _ = currentViewController?.presentingViewController {
                currentViewController?.dismiss(animated: false)
            }
            window.rootViewController = vc
            updateCurrentToVC(vc)
            completion?(true)
            
        case .push:
            var navigationOfVC: UIViewController? = currentViewController
            
            if let tabbar = currentViewController?.tabBarController {
                navigationOfVC = tabbar
            }
            
            guard let nav = navigationOfVC?.navigationController else {
                completion?(false)
                return
            }
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            nav.pushViewController(vc, animated: animated)
            CATransaction.commit()
            
            updateCurrentToVC(vc)
            
        case .modal:
            currentViewController?.present(vc, animated: animated) {
                completion?(true)
            }
            updateCurrentToVC(vc)
        }
    }
    
    public func pop(animated: Bool, completion: TransitionCompletion?) {
        if let navigationController = currentViewController?.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [unowned self] in
                self.updateCurrentToVC(navigationController)
                completion?(true)
            }
            navigationController.popViewController(animated: animated)
            CATransaction.commit()
        } else if let presenter = currentViewController?.presentingViewController {
            currentViewController?.dismiss(animated: animated, completion: { [unowned self] in
                self.updateCurrentToVC(presenter)
                completion?(true)
            })
        } else {
            completion?(false)
        }
    }
    
    public func dismiss(animated: Bool, completion: TransitionCompletion?) {
        if let presenter = currentViewController?.presentingViewController {
            currentViewController?.dismiss(animated: animated, completion: { [unowned self] in
                self.updateCurrentToVC(presenter)
                completion?(true)
            })
        } else if let navigationController = currentViewController?.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [unowned self] in
                self.updateCurrentToVC(navigationController)
                completion?(true)
            }
            navigationController.popViewController(animated: animated)
            CATransaction.commit()
        } else {
            completion?(false)
        }
    }
    
    public func popTo(_ vc: UIViewController, animated: Bool = true, completion: TransitionCompletion?) {
        if let navigationController = currentViewController?.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [unowned self] in
                self.updateCurrentToVC(navigationController)
                completion?(true)
            }
            navigationController.popToViewController(vc, animated: true)
            CATransaction.commit()
        } else {
            assertionFailure("Not in Navigation Stack and unsupported")
        }
    }
    
    public func popToRoot() {
        if let navigationController = currentViewController?.navigationController {
            CATransaction.begin()
            CATransaction.setCompletionBlock { [unowned self] in
                self.updateCurrentToVC(navigationController)
                
            }
            navigationController.popToRootViewController(animated: true)
            CATransaction.commit()
        }
    }
}
