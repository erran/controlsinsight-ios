class MainController < UIViewController
  def initWithNibName(name, bundle: bundle)
    super

    self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemMostRecent, tag: 1)
    self
  end

  def viewDidLoad
    super

    self.title = 'ControlsInsight'
    self.view.backgroundColor = UIColor.whiteColor
  end
end
