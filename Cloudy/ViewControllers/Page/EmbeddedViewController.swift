//
//  EmbededViewController.swift
//  Cloudy
//
//  Created by Bogdan Grozyan on 13.01.2021.
//

import UIKit

class EmbeddedPageVC: UIPageViewController {

    fileprivate var items: [UIViewController] = []
    
    var SecondPartOfPages: [locationParam] = (UserDefaults.standard.array(forKey: "pages") as? [locationParam] ?? [locationParam(name: "Current", lat: "", lon: "")])
    var firstPartOfPages = locationParam(name: "Current", lat: "", lon: "")
    var pages: [locationParam] = [locationParam(name: "Current", lat: "", lon: "")]
    
    var widthOfVC : CGFloat? //For CarouselItem
    
    func decodePages() {
        if let pagesTemp = UserDefaults.standard.data(forKey: "pages") {
            let decoder = JSONDecoder()
            if let decodedPages = try? decoder.decode([locationParam].self, from: pagesTemp) {
                self.SecondPartOfPages = decodedPages
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decodePages()
        
        pages = [firstPartOfPages] + SecondPartOfPages
        
        widthOfVC = view.frame.size.width
        dataSource = self
        populateItems()
        
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        decoratePageControl()
    }
    
    fileprivate func populateItems() {
        for t in self.pages {
            let c = createCarouselItemControler(with: t.name, lat: t.lat, lot: t.lon)
            items.append(c)
        }
    }
    
    fileprivate func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [EmbeddedPageVC.self])
        pc.numberOfPages = items.count
        
        pc.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
    fileprivate func createCarouselItemControler(with titleText: String?, lat: String?, lot: String?) -> UIViewController {
        let c = UIViewController()
        c.view = CarouselItem(titleText: titleText, width: widthOfVC!, lat: lat, lon: lot)
        
        return c
    }
}



extension EmbeddedPageVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = items.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        let before = index - 1
        return items[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(of: viewController), index < (items.count - 1) else {
            return nil
        }
        let after = index + 1
        return items[after]
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return items.count
    }
        
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}

