//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit

public enum SceneTransition {
    case root
    case push
    case modal
}

public protocol Scene {
    func createViewController() -> UIViewController
}

public typealias TransitionCompletion = (Bool) -> ()

public protocol SceneCoordinatorType {
    func transition(to scene: Scene, type: SceneTransition, animated: Bool, completion: TransitionCompletion?)
    func pop(animated: Bool, completion: TransitionCompletion?)
}
