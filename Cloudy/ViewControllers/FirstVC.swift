//
//  ViewController.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 20.11.2020.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    let keyForRequest = "721fcdbf6bd44bdf8e804034f720c0de"
    @IBOutlet weak var containerView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            UserDefaults.standard.set(keyForRequest, forKey: "key")
    }
    
}
//    func decodePages() {
//        if let pagesW = UserDefaults.standard.data(forKey: "pages") {
//        let decoder = JSONDecoder()
//        if let decodedPages = try? decoder.decode([locationParam].self, from: pagesW) {
//            self.pages = decodedPages
//        }
//        }
//    }
//    func encodePages() {
//        let encoder = JSONEncoder()
//        if let encodedPages = try? encoder.encode(pages) {
//            UserDefaults.standard.set(encodedPages, forKey: "pages")
//        }
//    }
//}
//        UserDefaults.standard.removeObject(forKey: "pages")
//        UserDefaults.standard.set(pages, forKey: "pages")
//        UserDefaults.standard.array(forKey: "pages")
