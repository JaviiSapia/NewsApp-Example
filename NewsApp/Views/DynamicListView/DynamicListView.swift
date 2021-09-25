//
//  DynamicListView.swift
//  NewsApp
//
//  Created by Javier Sapia on 06/09/2021.
//

import Foundation
import UIKit

@IBDesignable
class DynamicListView: UIView {
        
    static let TAG: String = "DynamicListView"
        
    @IBOutlet private weak var stackHeigth: NSLayoutConstraint!
    
    @IBOutlet var container: UIView!
        
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var stackView: UIStackView!    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()        
    }
    
    private func commonInit() {
        Bundle(for: DynamicListView.self).loadNibNamed(DynamicListView.TAG, owner: self, options: nil)
        container.frame = self.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(container)
    }
    
}
