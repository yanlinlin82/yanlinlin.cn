---
title: Promise- 异步编程的强大工具
date: 2024-01-06T22:07:00+08:00
badges: [ 公众号 ]
categories: [ 不靠谱颜论, 编程 ]
tags: [ javascript ]
---

<div class="p-3 text-center">
  <img class="img-fluid" src="/images/2024/0106/01.png" alt="题图" style="max-width:640px">
  <div><small>（题图由AI生成）</small></div>
</div>

如上一篇《黑魔法，白魔法，能摸鱼的就是好魔法》中提到，我最近为后续开发一些数据类产品，在通过尝试编写微信小程序，积累相关技术储备。面向项目实践的针对性学习，是个人在技术方面获得快速成长的首选方法。因此，在短暂的时间里，我对作为微信开发平台主要语言Javascript有了更多了解，觉得其中有很多既有趣又值得分享的内容，比如异步编程。这篇就来聊聊这个话题，以及Javascript中为此提供的一个强大设计Promise。
1. 异步编程的初识

首先想象一个日常场景：当你在网页或小程序上，点击一个按钮，向网络远端请求数据，由于各种不确定性，我们其实无法估计数据到底需要多长时间才能返回，也许几百毫秒，也许几分钟，甚至有可能在数据返回前，三体人通过水滴袭击了所有主干通讯，导致我们所请求的数据再也不可能返回，于是，在数据返回前，网页或小程序处于卡死状态，用户除了盯着惨白的屏幕发呆，再无法进行其他操作。这是个多么悲惨的故事啊。怎么解决呢，这就需要用到异步编程，或者说异步调用。
异步调用，是指函数在尚未全部执行完成函数体功能时，便尽早返回调用者，以便让调用者继续执行后续操作，而当函数体功能执行完成后，再设法通知调用者。如前文《软件程序结构演变不完全简史》所说，这是一种软件程序结构的新模式，让程序尽早返回调用者，从而使网页或小程序能够继续执行其他用户响应事件，确保用户界面保持流畅、不卡死，同时也能让程序员以一种合理的思考逻辑和编码方式，来有效处理IO、请求、定时任务等需要等待的任务，同时它们还与程序主逻辑的执行保持并行不悖。这的确是一种先进的编程技术。
微信作为国民级应用，为了确保用户体验顺畅，自然将其所提供的大多数常用接口函数，都以异步调用的形式呈现。可以说，只有把异步编程的基本范式熟练掌握并应用起来，小程序或现代网页应用的开发，才算是入了门。
2. Promise的诞生

最简单的异步编程可以通过回调函数（callback）实现。但是，当异步操作频繁且复杂时，回调函数很容易导致“回调地狱”（callback hell）——代码层层嵌套，难以阅读和维护。
为了解决这一问题，ES6（也被称为 ECMAScript 2015, 是 JavaScript 语言的一个重大版本更新）正式引入了 Promise 对象，一个代表了未来将要发生的事件的结果。Promise有三种状态：Pending（进行中）、Fulfilled（已成功）和 Rejected（已失败）。
2.1 基本使用

创建一个Promise非常简单：

let promise = new Promise(function(resolve, reject) {

  // ... 在这里编写具体的异步操作过程 ...

  if (/* 判断是否操作成功 */){

    resolve(value) // 将处理完成的数据，传给resolve函数

  } else {

    reject(error) // 构造错误信息（字符串），传给reject函数

  }

})
这里，Promise的构造需要以一个函数作为参数，该函数有两个参数，resolve和reject，均为函数类型，分别处理成功和失败的情况。这个用于构造Promise的函数，通常并不在其他地方被调用，因此如上面的代码所示，它可以不用指定函数名，而仅在构造过程中，嵌入（inline）地直接写出该实现即可。
Promise对象一旦创建，通过调用它的 .then() 函数，就可实际开始执行它所定义的异步操作。

promise.then(function(value) {

  // 处理成功情况

}, function(error) {

  // 处理失败情况

})
上述 .then() 函数是立即返回的。传给它的两个参数，都是函数，前一个是处理成功情况的，对应之前的 resolve，后一个是处理失败情况的，对应之前的 reject。当上面描述的异步操作执行完成后，根据结果成功与否，分别调用 resolve 或 reject ，最终其实也就传递到此，分别调用了这里定义的第一个或第二个函数。

.then() 函数其实只是建立了联系，告诉异步过程完成后，该回调哪个函数（包括成功情况和失败情况）。
当然，这两个函数也可以分开来写，分别提供给 .then() 和 .catch()。

promise.then(function(value) {

  // 处理成功情况

})

.catch(function(error) {

  // 处理失败情况

})
上述 .then 只传入一个参数，即处理成功情况的函数。而对于失败情况，放到了单独的 .catch() 中。

2.2 链式调用
Promise真正的强大之处在于它的链式调用（chaining）特性：

promise.then(function(value) {

  // 第一阶段

  ...

  return new Promise(...) // 返回一个新的Promise

})

.then(function(value) {

  // 第二阶段

})
在上面的代码中，传递给第一个 .then() 函数的回调函数中，其末尾返回了一个新的Promise，这使得当该 .then() 返回后，可以继续调用 .then() 函数，传递一个新的回调函数。这两个回调函数是顺序运行的，第二个回调函数必然在第一个回调函数结束后才会被调用。从而，实现了异步链式调用。同样地，上面整个代码（包括两个 .then()）都是在建立好回调链式关系后就立即返回的，并不影响后续用户界面响应，回调函数的真正执行，是在异步操作完成后，才单独发生的。

如果有多个异步调用，依葫芦画瓢，依次进行链式调用即可：


promise.then(function(value) {

  // 第一阶段

})

.then(function(value) {

  // 第二阶段

})

.then(function(value) {

  // 第三阶段

})

// ... 这里可以依次写入多个阶段

.then(function(value) {

  // 第N阶段

})
2.3 错误处理

在链式调用中，可以在每个阶段的 .then() 后加上 .catch() 进行错误处理即可：


promise

  .then(result => {/* 第一阶段处理成功场景 */})

  .catch(error => {/* 第一阶段处理错误 */})

  .then(result => {/* 第二阶段处理成功场景 */})

  .catch(error => {/* 第二阶段处理错误 */})

  // ... 这里可以依次写入多个阶段

  .then(result => {/* 第N阶段处理成功场景 */})

  .catch(error => {/* 第N阶段处理错误 */})
上述 .catch() 都是可选的，如果不处理，该阶段所产生的错误，会累积到最后一个 .catch() 被一次性处理。这种方式比传统的 try...catch （一层套一层）写法优雅多了。
值得一提的是，Promise 本身其实就是基于 try...catch 来实现的。我们可以通过在回调函数中的错误抛出，看出相应端倪。

promise

  .then(res => {

    // 阶段一

    if (/* 出现错误 */) {

      throw new Error('Error message')

    }

    return new Promise(...)

  })

  .then(res => {

    // 阶段二

    if (/* 出现错误 */) {

      return Promise.reject('Error message')

    }

    return new Promise(...)

  })

  .catch(error => {

    console.error('Caught an error:', error);

  })
		
上面的示例代码中，两个阶段分别以不同形式抛出错误，阶段一通过传统异常机制抛出异常，阶段二通过调用Promise.reject()函数，两者在结果上是等效的，都会将错误传递到最终的那个 .catch() 中。

3. Promise的进阶用法

3.1 同时处理多个Promise
Promise.all方法用于将多个Promise实例，包装成一个新的Promise实例。

Promise.all([promise1, promise2]).then(function(res) {

  // 当 promise1 和 promise2 都完成时执行

})

.catch(error => {

  // 任何一个或多个 promise 失败即触发

});
3.2 箭头式函数定义
不写出函数名，而将函数体直接嵌入（inline）地写在需要提供函数的地方，这种方式导致了关于“this 到底指向哪里”的诸多问题。
为了确保 this 指向当前所在的对象（比如小程序中的Page），被优先推荐的方式，是采用箭头式函数定义：


Page({

  onLoad: function() {

    promise.then(value => {

        // 在这里使用this，所指的就是Page对象

        ...

    })

  }

}
3. 总结

简单总结几点，作为应遵循的实践建议：

始终返回Promise: 在then链中始终返回新的值或Promise，以便可以继续链式调用。

分离链条: 不要在一个then中既处理resolve又处理reject。应该使用.then()处理resolve，使用.catch()处理reject，使逻辑清晰。

错误处理: 保证链的末端有.catch()来捕获前面可能出现的任何错误。

并行执行: 利用Promise.all()来并行处理多个异步操作。
Promise是JavaScript异步编程中的一大利器。通过使用Promise，我们可以写出更加清晰和可维护性更高的异步代码。虽然随着async/await的出现，使得异步代码更加简洁，但Promise仍是其背后的基石。

<div class="p-5 text-center">--- END ---</div>

<i><b>注：</b>本文首发表于[“不靠谱颜论”公众号](https://mp.weixin.qq.com/s/atFlcMdulXcaC1dZidOW0Q)，并同步至本站。</i>
