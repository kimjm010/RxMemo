//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by Chris Kim on 9/6/22.
//

import UIKit


protocol ViewModelBindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    // 바인딩에 사용할 메소드
    func bindViewModel()
}



extension ViewModelBindableType where Self: UIViewController {
    
    // 뷰컨트롤러에 추가된 viewModel 속성에 파라미터로 전달된 실제 viewModel을 저장
    // bindViewModel()메소드를 호출
    mutating func bind(viewModel: Self.ViewModelType) {
        self.viewModel = viewModel
        loadViewIfNeeded()
        
        
        bindViewModel()
    }
}
