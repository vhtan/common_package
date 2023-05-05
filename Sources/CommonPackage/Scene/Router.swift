//
//  File.swift
//  
//
//  Created by Tan Vo on 05/05/2023.
//

import UIKit

open class Router: NSObject {
    public static let shared = Router()
    
    private var coordinator: SceneCoordinator!
    
    public convenience init(window: UIWindow) {
        self.init()
        coordinator = SceneCoordinator(window)
    }
    
    public func setWindow(window: UIWindow) {
        coordinator = SceneCoordinator(window)
    }
    
    //Priortize navigation pop
    public func pop(_ animated: Bool = true, completion: TransitionCompletion? = nil) {
        return coordinator!.pop(animated: animated, completion: completion)
    }
    
    public func popTo(_ vc: UIViewController, _ animated: Bool = true, completion: TransitionCompletion? = nil) {
        return coordinator!.popTo(vc, animated: animated, completion: completion)
    }
    
    public func popToRoot() {
        return coordinator.popToRoot()
    }
    
    //Priortize dismiss presented
    public func dismiss(_ animated: Bool, completion: TransitionCompletion? = nil) {
        return coordinator!.dismiss(animated: animated, completion: completion)
    }
    
    public func updateCurrentToVC(_ viewController: UIViewController) {
        coordinator.updateCurrentToVC(viewController)
    }
}
