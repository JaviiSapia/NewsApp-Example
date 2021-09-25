//
//  GurdianService.swift
//  NewsApp
//
//  Created by Javier Sapia on 05/09/2021.
//

import Foundation
import RxSwift
import SwiftyJSON

class GuardianService {
        
    // MARK: - Declaración de variables
    private let urlSession: URLSession = URLSession.shared
    private let delegate: GuardianSeriviceDelegate?
    
    // MARK: - Constructor
    
    /**
        Parameter handler: ViewController que va a escuchar las respuestas del servicio
     */
    init(handler: GuardianSeriviceDelegate? = nil) {
        self.delegate = handler
        self.setUrlSessionConfiguration(urlSession: self.urlSession)
    }
    
    // MARK: - Metodos
    
    func setUrlSessionConfiguration(urlSession: URLSession) {
        urlSession.configuration.timeoutIntervalForRequest = 10.0
        urlSession.configuration.timeoutIntervalForResource = 10.0
    }
    
    /**
        Trae solo el contenido ("body")  del articulo en especifico
        - Parameter url: Endpoint del contenido a solicitar
        - Parameter onResponse: Devuelve el contenido por parametro
        - Parameter onError: Callback de error en caso que la petición haya fracazado
     */
    func getContent(url: GuardianURL,
                            onResponse: ((_ content: String) -> Void)? = nil,
                            onError: ((_ error: Error) -> Void)? = nil )  {
        urlSession.dataTask(with: url.url!) { data, response, error in
            if let data: Data = data {
                do {
                    let json = try JSON(data: data)
                    
                    // Obtengo el body del articulo dentro del JSON
                    if let body = json["response"]["content"]["fields"]["body"].string {
                        
                        // Transformo el texto en HTML a texto enriquecido
                        let attributedString: NSAttributedString = try
                            NSAttributedString(data: body.data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding:NSNumber(value: String.Encoding.utf8.rawValue)], documentAttributes: nil)
                        
                        // Vuelvo al Thread principal para realizar cambios en la UI
                        DispatchQueue.main.async {
                            self.delegate?.service(response: attributedString.string)
                            onResponse?(attributedString.string)
                        }
                    }
                } catch let error {
                    print("🔴", error.localizedDescription)
                    self.delegate?.service(on: error)
                    onError?(error)
                }
            }
        }.resume()
    }
    
    /**
        Trae todo el contenido configurado por los parametros de la URL
        - Parameter url: Endpoint del contenido a solicitar
        - Parameter onResponse: Devuelve un array de articulos
        - Parameter onError: Callback de error en caso que la petición haya fracazado
     */
    func search(url: GuardianURL, onResponse: ((_ articles: ArraySlice<Article>) -> Void)? = nil, onError: ((_ error: Error) -> Void)? = nil )  {
        delegate?.service(response: [])
        urlSession.dataTask(with: url.url!) { data, response, error in
            if let data: Data = data {
                do {
                    let json = try JSON(data: data)
                    
                    // Creo un array de articulos con el contenido del json
                    var articles: ArraySlice<Article> = []
                    for object: JSON in json["response"]["results"].arrayValue {
                        articles.append(Article(json: object))
                    }
                    // Vuelvo al Thread principal para realizar cambios en la UI
                    DispatchQueue.main.async {
                        self.delegate?.service(response: articles)
                        onResponse?(articles)
                    }
                } catch let error {
                    print("🔴", error.localizedDescription)
                    self.delegate?.service(on: error)
                    onError?(error)
                }
            }
        }.resume()
    }
    
}
