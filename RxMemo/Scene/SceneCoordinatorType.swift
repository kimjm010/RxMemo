//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import Foundation
import RxSwift


protocol SceneCoordinatorType {
    
    // 리턴형이 completable이어서 여기에 구독자를 추가하여 화면전환이 완료된 후에 원하는 작업을 추가할 수 있음
    // completion Handler랑 비슷한 것
    
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
