//
//  TagsView.swift
//  NewsApp
//
//  Created by Javier Sapia on 02/09/2021.
//

import UIKit
import RxSwift

class TagReusableCell: UICollectionViewCell {

    static let TAG: String = "TagReusableCell"

    var id: Int?
    @IBOutlet private weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setObservable(observable: Observable<Int>) {
        observable.subscribe { index in
            self.setIsActive(isActive: (index.element == self.id!))
        }
    }
    
    private func setIsActive(isActive: Bool) {
        UIView.animate(withDuration: 0.3) {
            if(isActive) {
                self.containerView.backgroundColor = UIColor.black
                self.title.textColor = UIColor.white
            } else {
                if #available(iOS 13.0, *) {
                    self.containerView.backgroundColor = UIColor.systemBackground
                } else {
                    self.containerView.backgroundColor = UIColor.white
                }
                self.title.textColor = UIColor.systemGray
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let frame: CGSize = CGSize(
            width: self.title.intrinsicContentSize.width * 1.1,
            height: layoutAttributes.frame.height)
        layoutAttributes.size = frame
        return layoutAttributes
    }
    
}
