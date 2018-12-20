# CVTabBarController

#### 图片展示


#### 引入工程
使用CocoaPod
```
pod 'CVTabBarController' 
```
#### CVTabBarController使用方法
  
  tabBar使用相当简单，引入组件到项目中后，可集成自本类，设定好需要显示到tabBar上的控制器，然后调用设置数据源和需要显示出来的控制器的index即可
  ```
  // 设置数据源，此时数据源个数不一定为最终显示的个数和顺序
  viewControllers = [nav_Home, nav_Recommend, nav_Test, nav_ShoppingCart, nav_SmallVideo, nav_Friends]
  // 哈哈，这里的方法才是控制tabBar上需要显示的控制器和顺序，可以根据项目需求随时调整
  showItems = [0, 1, 2, 3]
  ```
  辅助方法：
  1. 特殊的item，可以插入一个特殊的位置，效仿咸鱼
  ```
  let cycle = UIView(frame: CGRect(x: 0, y: -20, width: 49, height: 49))
        cycle.layer.cornerRadius = 49 / 2
        cycle.layer.masksToBounds = true
        cycle.backgroundColor = UIColor.red
        view.addSubview(cycle)
        
  insert(view: view, at: 2)
  ```
  2. 泡泡
  ```
  /// 更新item上的paopao数字, （中心的）偏移量，是否隐藏 ； 当text==nil时，显示圆点
  func updatePaopao(text: String?, offset: CGSize = CGSize(width: 15, height: -10), at index: Int, isHidden: Bool = false)
  ```
  3. 在外界修改tab上的index
  ```
  func changeToIndex(_ index: Int)
  ```



  
