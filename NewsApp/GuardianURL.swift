//
//  GuardianURL.swift
//  NewsApp
//
//  Herramienta para crear URLs con los parametros necesarios para mostrar
//  los distintos articulos y información adicional que queramos
//

import Foundation

class GuardianURL {
    
    // MARK: - Declaración
    
    private(set) var url: URL?
    // Parametros indispensables para inflar las vistas
    private static let fields: [String] = ["thumbnail", "headline", "trailText", "body", "firstPublicationDate", "apiUrl" ]
    // Array con los parametros indispensables y el token de usuario
    private static var requiredParamenters: [URLQueryItem] {
        return [
            URLQueryItem(name: "api-key", value: (Bundle.main.object(forInfoDictionaryKey: "Api-key") as! String)),
            URLQueryItem(name: "show-fields", value: fields.joined(separator: ","))
        ]
    }
    
    
    // MARK: - Metodos de construcción
    
    /**
        Crea un URL en base al parametro apiKey correspondiente al articulo
        - Parameter url: La url del apiKey del que se quiere obtener información
        - Returns: Una nueva instancia de GuardianURL
     */
    static func BuildFromApiUrl(url: String) -> GuardianURL {
        var tempUrl: URLComponents = URLComponents(string: url)!
        tempUrl.queryItems = requiredParamenters
        let guardianUrl: GuardianURL = GuardianURL()
        guardianUrl.url = tempUrl.url!
        return guardianUrl
    }
    
    /**
        Crea un URL destinada a las últimas noticias
        - Parameter section: El tipo de contenido que desea traer
        - Returns: Una nueva instancia de GuardianURL
     */
    static func Build(section: String? = nil) -> GuardianURL {
        var url: URLComponents
        url = URLComponents()
        url.scheme = "https"
        url.host = "content.guardianapis.com"
        url.path = "/search"
        url.queryItems = requiredParamenters
        if let section = section {
            url.queryItems!.append(URLQueryItem(name: "section", value: section))
        }
        let guardianUrl: GuardianURL = GuardianURL()
        guardianUrl.url = url.url!        
        return guardianUrl
    }
    
}
