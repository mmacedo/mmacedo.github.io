---
layout: post
title: "Javascript Not Minus One Operator"
categories: javascript coffeescript
comments: true
---

In most languages if you want to check if something is in a array or string, you use functions named indexOf or any variant thereof. The signature and contract don't usually deviate much, specially in languages with zero-based indexes.

In Javascript, both [Array's](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/indexOf "Array indexOf method") and [String's](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/String/indexOf "String indexOf method") indexOf return minus one (-1) for not found. Minus one isn't particularly semantic, and checking for it tends to produce the most verbose and technical bits of otherwise [cleanly written code](http://www.shelfari.com/books/4017020/Clean-Code "Clean Code (2008) by Robert C. Martin").

``` coffeescript Comparison operators
hello = 'Hello World!'
if hello.indexOf('World') isnt -1 and hello.indexOf('Hello') is -1
  console.log 'Has World, but not Hello'
```

It turns out there is operator that will return 0 (a falsy value in Javascript) if, and only if it gets a -1. Isn't that convenient?

Tip seen in [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/), because CofeeScript has a [special idiom](http://arcturo.github.com/library/coffeescript/04_idioms.html) for arrays, but not for strings.

``` coffeescript Complement Operator (or Not Minus One Operator)
hello = 'Hello World!'
if ~hello.indexOf('World') && !~hello.indexOf('Hello')
  console.log 'Has World, but not Hello'
```

It is also [not very semantic](http://stackoverflow.com/questions/791328/how-does-the-bitwise-complement-operator-work "How does the bitwise complement (~) operator work?"), and if I had seen this code yesterday I wouldn't understand it. I would probably use [an "include" implementation](http://underscorejs.org/#include "Underscore.js include method") for arrays/collections or [regular expressions](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/RegExp/test "RegExp test method") for strings, but it doesn't hurt to have other options. This syntax is almost universal (as long as 0 is evaluted as false, so no Ruby) and it works with CofeeScript too, it is just a matter of knowing the operator.
