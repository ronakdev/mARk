//
//  HelpPageViewController.swift
//  mARk
//
//  Created by Ronak Shah on 2/17/19.
//  Copyright © 2019 Ronak Shah. All rights reserved.
//

import UIKit

class HelpPageViewController: UIPageViewController {
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.vcWithName("welcomeVC"), self.vcWithName("introPage1"),
                self.vcWithName("introPage2"), self.vcWithName("introPage3"),
                self.vcWithName("permissionsVC"), self.vcWithName("finalPage")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        if let firstVC = self.orderedViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension HelpPageViewController: UIPageViewControllerDataSource {
    
    func vcWithName(_ id: String) -> UIViewController {
       return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return self.orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = self.orderedViewControllers.firstIndex(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let count = self.orderedViewControllers.count
            
            guard count != nextIndex else {
                return nil
            }
            
            guard count > nextIndex else {
                return nil
            }
            
            return self.orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
