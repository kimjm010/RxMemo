//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift
import RxCocoa


class CommonViewModel: NSObject {
    // 앱을 구성하는 모든 Scene은 navigation Controller에 임베드 되기 때문에 navigation title 필요
    let title: Driver<String>
    
    
    // 프로토콜형식으로 선언하여 의존성을 쉽게 수정할 수 있도록 함
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
