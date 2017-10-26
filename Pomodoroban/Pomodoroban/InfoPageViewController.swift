import UIKit
import DDTRepeater

protocol InfoPageViewControllerDelegate {
    func infoPageViewController(_ infoPageViewController: InfoPageViewController)
}

class InfoPageViewController: UIPageViewController {
    
    var repeater:DDTRepeater?
    
    var currentViewController:UIViewController!
    
    var infoDelegate:InfoPageViewControllerDelegate?
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        
        super.init(transitionStyle: style, navigationOrientation: .horizontal, options:options )
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        
        let vc1 = self.infoViewController({ (void) -> String in
            return "Use allergy-proof covers on pillows and mattresses."
        })
        
        let vc2 = self.infoViewController({ (void) -> String in
            return "Do not allow pets in bedrooms or on furniture."
        })
        
        let vc3 = self.infoViewController({ (void) -> String in
            return "Remove carpets and stuffed toys from bedrooms."
        })
        let vc4 = self.infoViewController({ (void) -> String in
            return "Fix leaky bathroom fixtures, these can be a hiding place for mold."
        })
        
        let vc5 = self.infoViewController({ (void) -> String in
            return "Avoid areas where people smoke."
        })
        
        let vc6 = self.infoViewController({ (void) -> String in
            return "Avoid hardsh cleaning products and chemicals."
        })
        
        let vc7 = self.infoViewController({ (void) -> String in
            return "Reduce stress."
        })
        
        let vc8 = self.infoViewController({ (void) -> String in
            return "Pay attention to air quality."
        })
        
        let vc9 = self.infoViewController({ (void) -> String in
            return "Exercise indoors."
        })
        
        let vc10 = self.infoViewController({ (void) -> String in
            return "Take control of seasonal allergies."
        })
        
        let vc11 = self.infoViewController({ (void) -> String in
            return "Make sure people around you know you have asthma."
        })
        
        let vc12 = self.infoViewController({ (void) -> String in
            return "Be prepared - just in case."
        })
        
        
        return [vc1, vc2, vc3, vc4, vc5, vc6,vc7,vc8,vc9,vc10,vc11,vc12]
        
    }()
    
    
    func infoViewController(_ stringBlock: @escaping (Void) -> String) -> InfoViewController {
        
        let infoViewController = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        
        infoViewController.stringBlock = stringBlock
        
        return infoViewController
    }
    
    func didBecomeActive() {
        self.createAutoscrollRepeater()
    }
    
    func willResignActive() {
        self.repeater?.invalidate()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
            self.currentViewController = firstViewController
        }
        self.createAutoscrollRepeater()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    
    func showNextPage(animated:Bool) {
        let nextVCIndex = [1,2,3,4,5,6,7,8,9,10,11,0]
        let currentIndex = self.orderedViewControllers.index(of: self.currentViewController)
        let nextVC = self.orderedViewControllers[nextVCIndex[currentIndex!]]
        self.setViewControllers([nextVC], direction: .forward, animated: animated) { (Bool) in
            self.currentViewController = nextVC
        }
        
    }
    
    func createAutoscrollRepeater() {
        self.repeater?.invalidate()
        self.repeater = DDTRepeater.repeater(5.0, fireOnceInstantly: false) {
            self.showNextPage(animated: true)
            
        }
    }
}

extension InfoPageViewController: UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        
        self.currentViewController = pageViewController.viewControllers!.first
        
        self.createAutoscrollRepeater()
        
        let  firstViewControllerIndex = orderedViewControllers.index(of: self.currentViewController )
        
        print(firstViewControllerIndex)
        
        
    }
}

extension InfoPageViewController: UIPageViewControllerDataSource {
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        
        guard var viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == 0 || viewControllerIndex == NSNotFound {
            viewControllerIndex = self.orderedViewControllers.count
        }
        
        viewControllerIndex -= 1
        
        return orderedViewControllers[viewControllerIndex]
        
        
        
        
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex == NSNotFound {
            return nil
        }
        
        viewControllerIndex += 1
        if viewControllerIndex == self.orderedViewControllers.count {
            viewControllerIndex = 0
        }
        
        return orderedViewControllers[viewControllerIndex]
        
        
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        print(firstViewControllerIndex)
        
        
        return firstViewControllerIndex
    }
    
    
}






