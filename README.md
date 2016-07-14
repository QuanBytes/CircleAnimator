# CircleAnimator


![icon](http://v2.freep.cn/3tb_1607141114067afv512293.gif"宠物小精灵")

主界面和菜单之间的循环动画，正如你在上边看到的.

每次我看到一个如此优雅的动画，我就会像每个人想的那样，我应该怎样实现他...--等等，难道正常的人不都是这样想的么？

在这个教程里，你将学会如何使用`swift`实现这个酷酷的动画.在这个过程中，你将学会如果使用`shape layers`,`masking`,`UIViewControllerAnimatedTransitioning协议`和`UIPercentDrivenInteractiveTransition类`等等。

注意在这个教程中假设你具备iOS开发基础。

##总体策略

这个动画发生在你从一个视图跳转到另外一个视图。

在iOS中，你通过使用导航控制器`UINavigationController`实现另个视图控制器间的自定义动画。你也可以使用iOS7的`UIViewControllerAnimatedTransitioning协议`实现过渡动画效果。å

你必须了解一下细节，其实是这个协议能够帮你做到

- 指定动画持续时间
- 创建一个视图容器关联两个视图控制器
- 实现任何你能够想象的动画

你能够使用这个完成高级复杂的UIView动画或者简单低级的Core Animation(在这里，你将实现后者)

##实现策略

既然现在你知道了编码动作在哪里发生，下一点讨论的就是如何真真的去实现这个循环过渡动画

如果你想用自己的话描述这个动画，大致应该是这样的：

- 这里有个圆 在视图的右上方，就像一个按钮打开了另外一个视图
- 话句话说，这个圆圈像一个遮罩，它既打开了里面的一切，也会隐藏外面的一切

你可以通过`CALayer`的`mask`属性实现这个效果。你也可以通过它的alpha通道来决定这个layer的那一部分能够被展示

![icon](https://cdn5.raywenderlich.com/wp-content/uploads/2014/10/mask-diagram-700x381.png)

现在你知道了什么是mask,下一步就是决定使用哪一种mask.既然动画效果是一个原型的遮罩。那自然就应该使用`CAShpeLayer`。实现这个圆形动画，只需要简单的增加原型遮罩的半径就OK啦


##自定义动画

```
注意：省略了前面构建项目，直接专注于动画创建。具体项目下载

```

为了写一个自定义的`push` 或者 `pop `动画，你需要实现`UINavigationControllerDelegate`协议的`animationControllerForOperation`方法。

在 `iOS\Source\Cocoa Touch Class` 创建一个新文件，设置类名为`NavigationControllerDelegate`.

创建完文件后，实现该类，如下

```
class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
 
}
```

然后设置UINavigationController的代理，回到NavigationControllerDelegate这个类中,添加方法

```
func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
  return nil
}

```

注意这个方法的实现是空的，你待会就会实现它

这个方法接收导航控制器中相互跳转的两个视图控制器，你的任务就是返回一个`UIViewControllerAnimatedTransitioning`类

所以你需要创建一个，接着创建一个名为`CircleTransitionAnimator`的类（File\New\File）

![icon](https://cdn1.raywenderlich.com/wp-content/uploads/2014/10/Screenshot-2014-10-23-15.52.17-700x410.png)

确定你实现了`UIViewControllerAnimatedTransitioning`协议

```
class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

```

下一步就是实现协议需要实现的方法

先加一个下面的方法

```

func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.5
}
```
在这个方法中，你返回的是动画的时间。你想让动画持续0.5秒。你就返回0.5


接下来给类加一个属性
```

weak var transitionContext: UIViewControllerContextTransitioning?
```

你会在 `transition context`中用到它

下面实现第二个方法
```
func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        //1
        self.transitionContext = transitionContext
        
        //2
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
        let button = fromViewController.button
        
        //3
        containerView!.addSubview(toViewController.view)
        
        //4
        let circleMaskPathInitial = UIBezierPath(ovalInRect: button.frame)
        let extremePoint = CGPoint(x: button.center.x - 0, y: button.center.y - CGRectGetHeight(toViewController.view.bounds))
        let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(button.frame, -radius, -radius))
        
        //5
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.CGPath
        toViewController.view.layer.mask = maskLayer
        
        //6
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
        maskLayerAnimation.duration = self.transitionDuration(transitionContext)
        maskLayerAnimation.delegate = self
        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
    }
    
让我们来一步步分析这些代码

1.我们先引用`transitionContext`这个对象，保证我们在函数的作用域外能够引用它
2.获得视图容器，开始视图控制器和结束视图控制器。还有引发事件发生的button.视图容易是动画发生的视图。开始视图控制器和结束视图控制器是动画的参与者。
3.将结束视图添加到视图容器中
4.创建两个圆形的贝塞尔曲线。一个大小和button一样，另一个有足够大的半径覆盖整个半径。最终动画将是这两个之间的动画
5.创建一个`CAShapeLayer`来展示这个圆形遮罩。将它赋值给结束的圆。避免动画结束的回弹。
6.创建一个基于贝塞尔曲线的`CABasicAnimation`。作用于开始动画视图和结束的动画视图。同时设置动画的代理，用来处理动画结束的一些收尾工作。

下面实现动画的收尾工作

```

override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
     self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
     self.transitionContext?.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
}
```
下一步就是使用这个动画效果了，在 `NavigationControllerDelegate.swift` 中

```
func navigationController(navigationController: UINavigationController,
 animationControllerForOperation operation: UINavigationControllerOperation,
 fromViewController fromVC: UIViewController,
 toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CircleTransitionAnimator()
}
```
到此这个酷炫的动画就实现了，赶紧来试试吧！

[猛戳此处获取代码](https://github.com/MrLQ/CircleAnimator) 










