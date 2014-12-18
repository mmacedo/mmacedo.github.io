---
layout: post
title: Functional JavaScript
categories: javascript coffeescript underscorejs lodash
comments: true
---

In [functional languages](http://en.wikipedia.org/wiki/Functional_programming), code consists mainly of processing lists in a recursive manner. A limited list of patterns in processing lists emerge so often that all functional languages provide at least some [high-order functions](http://en.wikipedia.org/wiki/Higher-order_function), that are very well written and optimized. The most common and useful high-order functions, the primitives, are (may vary) [each](http://en.wikipedia.org/wiki/Foreach) (only for imperative programming), [filter](http://en.wikipedia.org/wiki/Filter_(higher-order_function\)), [map](http://en.wikipedia.org/wiki/Map_(higher-order_function\)) and [reduce](http://en.wikipedia.org/wiki/Fold_(higher-order_function\)).

## Functional implementations

Some notes about the available implementations of high-order functions.

### About Recursion

Even though programming functional style may be awesome, don't write [recursive functions](http://en.wikipedia.org/wiki/Recursion_(computer_science\)) in JavaScript, because:

* JavaScript engines usually have limit on the stack size, so your code will break easily;
* JavaScript [standard](http://en.wikipedia.org/wiki/ECMAScript) doesn't mention [Tail Call Optimization](http://en.wikipedia.org/wiki/Tail_call) and most engines don't implement it;
* Function calls add a lot of overhead, even high-order functions aren't ideal.
* [Continuation-Passing Style](http://en.wikipedia.org/wiki/Continuation-passing_style) would be prohibitive because of the stack size limit and the overhead of functions;

High-order functions are usually very optimized because they are not recursive. They still need to call at least one function per iteration, but the difference is almost always negligible. Most JavaScript code do not need to be real time, so it is a good thing to use high-order functions to make beatiful, clean code.

### Native in JavaScript

There are native functions for all primitives, but they are only for arrays. Another consideration is that they are mostly from ES5 standard and even the older of them was not implemented in IE 8. You should use them directly only if you are not programming for browsers, like in Node.js.

### Underscore.js / Lo-Dash

There is a library in JavaScript that has become famous because it provides an extensive support for high-order functions in JavaScript for both collections and object hashes. The name of the library is [Underscore.js](http://underscorejs.org/). Then there is [Lo-Dash](http://lodash.com/), that claims to be a drop-in replacement for Underscore.js. Even though they claim to be faster and better, I haven't tested it and I am yet to find why the fork.

### List Comprehensions

List comprehensions are a syntactic equivalent for high-order functions. JavaScript doesn't have any, but [CoffeeScript](http://en.wikipedia.org/wiki/CoffeeScript) does. Since I write most JavaScript examples in CoffeeScript, I will provide those too.

## Each

The idea of each is to iterate over a list and execute something without producing a new list. It is a imperative construct and it is very often available in imperative languages as [for/foreach constructs](http://michelpm.com/blog/2012/09/10/iterating-collections-in-javascript/). The native function is [forEach](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/forEach).

``` coffeescript each
arr = [1..3]
foo = (value, key) -> alert "arr[#{key}] = #{value}"

### Native ###
arr.forEach foo

### Underscore.js / Lo-Dash ###
_.each arr, foo
_.forEach arr, foo

### Comprehension ###
foo value, index for value, index in arr
```

## Filter

Also known as select, the filter primitive returns a list with the items that pass a test function. The native function is [filter](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/filter). It is the [selection](http://en.wikipedia.org/wiki/Selection_(relational_algebra\)) operator ([WHERE](http://en.wikipedia.org/wiki/Where_(SQL\)) in SQL).

``` coffeescript filter
arr = [1..3]
isOdd = (value) -> value % 2 is 1

### Native ###
alert arr.filter(isOdd)

### Underscore.js / Lo-Dash ###
alert _.filter(arr, isOdd)
alert _.select(arr, isOdd)
alert _.reject(arr, isOdd) # Opposite

### Comprehension ###
alert (value for value in arr when isOdd(value))
alert (value for value in arr when value % 2 is 1)
```

## Map

Also known as collect, the map primitive returns a list with the items returned from the map function. The native function is [map](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/map). It is the [projection](http://en.wikipedia.org/wiki/Projection_(relational_algebra\)) operator ([SELECT](http://en.wikipedia.org/wiki/Select_(SQL\)) in SQL).

``` coffeescript map
arr = [1..3]
format = (value) -> value.toFixed(2)

### Native ###
alert arr.map(format)

### Underscore.js / Lo-Dash ###
alert _.map(arr, format)
alert _.collect(arr, format)

### Comprehension ###
alert (format(value) for value in arr)
alert (value.toFixed(2) for value in arr)
```

## Reduce

Also known as fold or inject, the reduce primitive returns a single value accumulated by calling an [aggregate function](http://en.wikipedia.org/wiki/Aggregate_function) on each item, always passing as the first parameter the value accumulated as returned from the last iteration call. This is the most often non-understood from the primitives, but it is not complicated at all. The native method is [reduce](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/reduce).

``` coffeescript Aggregate functions: sum, mult
sum = (sum, value) -> sum + value
mult = (product, value) -> product * value
```

Our first aggregate functions are pretty straightforward.

``` coffeescript Aggregate function: max
max = (max, value) -> Math.max(max, value)
```

Since the aggregate function accepts four parameters (previousValue, currentValue, index and parameter), you can not pass [Math.max](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Math/max) directly to reduce, because it tries to get the maximum value for all parameters passed.

``` coffeescript Aggregate function: join
join = (str, value) ->
  if str is ''
    value.toString()
  else
    "#{str}, #{value.toString()}"
```

This is also straightforward, to show what you can do. Note that the accumulated value is from a different type than the values being iterated.

``` coffeescript Aggregate function: avg
avg = (sum, value, index, arr) ->
  if index is arr.length - 1
    (sum + value) / arr.length
  else
    sum + value
```

Several implementations of reduce would accept a second function that returns the result based on the value returned from the last iteration, while simpler implementations just return the value from the last iteration. The reason from that second function is to implement aggregate functions like avg. Our implementation assumes that the list is being iterated from left to right (can not be called with reduceRight) and from the beginning to the end in the same interation (can not be merged with other iterations, therefore can not be [parallelized](http://en.wikipedia.org/wiki/Automatic_parallelization)). [This](https://gist.github.com/3696508) is a good solution in a bad technology.

``` coffeescript reduce
arr = [1..3]

### Native ###
alert "The sum is #{arr.reduce(sum, 0)}, and the product is #{arr.reduce(mult, 1)}."

### Underscore.js / Lo-Dash ###
alert "The sum is #{_.reduce(arr, sum, 0)}, and the product is #{_.reduce(arr, mult, 1)}."
```

Something worth noting: there is no reduce syntax for CoffeeScript. You can always use the other solutions (the code above already is in CoffeeScript) or even a loop, since it is always pleasant to write good JavaScript in CoffeeScript.

``` coffeescript reduce by hand
sum = 0
sum += value for value in arr
```

### Reduce right

Usually where is reduce, there is also a reduceRight. It iterates from the last to the first item. It seldom makes a differece, but it may, and if it does, it may be an issue instead of benefit. As a rule of thumb, use reduce unless you know why you are not. The native method is [reduceRight](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/ReduceRight).

``` coffeescript reduceRight by hand
sum = 0
sum += value for value in arr by -1
```
