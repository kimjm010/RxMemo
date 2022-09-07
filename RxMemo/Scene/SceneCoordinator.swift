//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa



extension UIViewController {
    var sceneViewController: UIViewController {
        return self.children.last ?? self
    }
}




class SceneCoordinator: SceneCoordinatorType {
    
    private let bag = DisposeBag()
    
    // SceneCoordinator는 화면전환을 처리하기 때문에 window 인스턴스, 현재화면을 표시하는 scene을 갖고있어야 함.
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        // 화면전환 결과를 방출할 subject
        let subject = PublishSubject<Never>()
        
        // 실제 scene을 생성
        let target = scene.instantiate()
        
        switch style {
        case .root:
            
            currentVC = target.sceneViewController
            window.rootViewController = target
            
            subject.onCompleted()
            
        case .push:
            
            print(currentVC)
            
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            
            nav.rx.willShow
                .withUnretained(self)
                .subscribe(onNext: { (coordinator, evt) in
                    coordinator.currentVC = evt.viewController.sceneViewController
                })
                .disposed(by: bag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            
            subject.onCompleted()
            
        case .modal:
            
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            
            currentVC = target.sceneViewController
        }
        
        
        // 리턴형이 completable로 되어 있기 때문에
        // 처음에 publishedSubject가 아닌 completable로 만들 수 있는데, create 연산자로 만들어야 하고 closure내부에서 구현해야하기 때문에 코드가 필요 이상으로 복잡해짐
        // => PublshedSUbject + asCompletable()로 함
        return subject.asCompletable()
    }
    
    
    @discardableResult
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            
            // 현재 scene이 모달 방식으로 되어있으면 dismiss하기
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }
            
            // 현재 scene이 navigation Stack에 푸시되어 있으면 pop하기
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!.sceneViewController
                completable(.completed)
            }
            
            else {
                completable(.error(TransitionError.unknown))
            }
            
            return Disposables.create()
        }
    }
}
