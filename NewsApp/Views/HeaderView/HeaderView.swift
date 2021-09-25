//
//  HeaderView.swift
//  NewsApp
//
//  Created by Javier Sapia on 04/09/2021.
//

import UIKit
import SkeletonView

class HeaderView: UIView {
    // MARK: - Declaración de variables
    static let TAG: String = "HeaderView"
    
    // MARK: - Configuración de las distintas vistas
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var section: UILabel! {
        didSet {
            section.skeletonCornerRadius = 30
            section.isSkeletonable = true
            section.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var trailText: UILabel!
    @IBOutlet weak var headline: UILabel! {
        didSet {
            headline.isSkeletonable = true
            headline.showAnimatedSkeleton()
            headline.skeletonCornerRadius = 30
            headline.adjustsFontSizeToFitWidth = true
            headline.allowsDefaultTighteningForTruncation = true
            headline.sizeToFit()
        }
    }
    @IBOutlet weak var date: UILabel!

    // MARK: - Se infla la UIView
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle(for: HeaderView.self).loadNibNamed(HeaderView.TAG, owner: self, options: nil)
        addSubview(container)
        container.frame = self.bounds
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    /**
        Infla la vista con la información traida del articulo
        - Parameter article: El articulo que se desea representar
     */
    func loadFromArticle(article: Article) {
        headline.hideSkeleton()
        section.hideSkeleton()
        headline.text = article.headline
        section.text = article.section
        date.text = article.date
        trailText.text = article.trailtext
    }
    
    
            
}
