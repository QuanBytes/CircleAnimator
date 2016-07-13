# CircleAnimator

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






