//
//  TagsViewController.swift
//  NewsApp
//
//  Maneja una lista de Secciones/Categorias
//

import UIKit
import RxSwift

class SectionsViewController: UIViewController {

    // MARK: - Declaración de variables
    static let TAG: String = "TagsViewController"
    weak var delegate: SectionsListDelegate?
    var active: String?
    private let observer: BehaviorSubject = BehaviorSubject<Int>(value: 0)
    private let tags: [String] = ["News", "World", "Coronavirus", "Technology", "Business", "Environment", "Science", "Football"]
        
    // MARK: - Configuración de las distintas vistas
    @IBOutlet weak var tagsCollectionView: UICollectionView! {
        didSet {
            self.tagsCollectionView.delegate = self
            self.tagsCollectionView.dataSource = self
            self.tagsCollectionView.showsHorizontalScrollIndicator = false
            self.tagsCollectionView.showsVerticalScrollIndicator = false
            self.tagsCollectionView.bounces = false
            self.tagsCollectionView.register(UINib(nibName: SectionCell.TAG, bundle: Bundle.main), forCellWithReuseIdentifier: SectionCell.TAG)
        }
    }
    
    @IBOutlet weak var tagsCollectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            tagsCollectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            tagsCollectionViewFlowLayout.scrollDirection = .horizontal
            tagsCollectionViewFlowLayout.minimumLineSpacing = 3
        }
    }
    
    
    /**
        Crea una nueva instancia de SectionsViewCotroller
        - Parameter parent: El ViewController que maneja al contenedor donde se renderizará la nueva instancia del ViewController
        - Parameter container: UIView donde se mostrará la lista
     */
    static func newInstance(parent: UIViewController, container: UIView) -> SectionsViewController {
        let controller: SectionsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TAG) as! SectionsViewController
        parent.addChild(controller)
        container.addSubview(controller.view)
        controller.view.frame = container.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: parent)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension SectionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Se le indica al subject el index seleccionado
        // Con esto evitamos renderizar nuevamente todos los elementos de la lista y se ven afectados solo las dos vistas deben cambiar de estado
        observer.onNext(indexPath.row)
        
        // Notifico al ViewController que un nueva sección fue seleccionada
        delegate?.section(selectedAt: tags[indexPath.row])
        if indexPath.row != 0 {
            self.active = nil
        } else {
            self.active = tags[indexPath.row]
        }
    }
    
}

extension SectionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCell.TAG, for: indexPath) as! SectionCell
        cell.title.text = tags[indexPath.row]
        cell.id = indexPath.row
        cell.setObservable(observable: observer)
        return cell
    }
    
}

extension SectionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
