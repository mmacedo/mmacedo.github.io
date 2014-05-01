---
layout: post
title: Iterating Collections In JavaScript
categories: javascript coffeescript underscorejs lodash jquery nodejs
---

When I iterate in any language, I like to have a list of somethings to iterate because I can use more idiomatic code and have more explicit initial state, state changes and exit conditions. Most languages have a slightly different for/foreach that iterates over things that are considered enumerable by the language. In JavaScript we have two types of enumerable objects: array-like objects, also known as collections or simply arrays; and objects, also known as object hashes or associative arrays, even though they are just any JavaScript object that is used for that purpose.

## Control Structures

### Arrays

In Javascript (ES6) there is a [for..of](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/for...of) structure to iterate over arrays, but it is not safe to use it in browsers just yet.

``` javascript
var arr = [1, 2, 3];
// for
for (var i = 0; i < arr.length; ++i) {
  foo(arr[i]);
}
// for..of
for (var i of arr) {
  foo(i);
}
```

In CoffeeScript you can use the for..in for that. It will generate a regular `for`, so unlike it is JavaScript counterpart, it is safe.

``` coffeescript for..in
arr = [1..3]

### for ###
for i in [0...arr.length]
  foo arr[i]

### for..in ###
for i in arr
  foo i
```

### Objects

In JavaScript there is a well supported structure to iterate on the properties of a object. It is called [for..in](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Statements/for...in).

``` javascript
var obj = { a: 'a', b: 'b' };
for (var key in obj) {
  foo(obj[key]);
}
```

In CoffeeScript you use the for..of for that. Yes, that is right, CoffeeScript uses "for..in" for arrays and "for..of" for objects, exactly the opposite of JavaScript. If you think about it, the CoffeeScript way sounds better.

``` coffeescript for..of
obj = a: 'a', b: 'b'
for key, val of obj
  foo val
```

The problem is that it returns also inherited properties, to solve that you can either use [hasOwnProperty](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/hasOwnProperty) if in a browser or [getOwnPropertyNames](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/getOwnPropertyNames)/[Object.keys](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Object/keys) (both ES5).

``` javascript
var obj = { a: 'a', b: 'b' };
// for..in
for (var key in obj) {
  if ({}.hasOwnProperty.apply(obj, [key])) {
    foo(obj[key]);
  }
}
// Object.keys
var keys = Object.keys(obj);
for (var i = 0; i < keys.length; ++i) {
  foo(obj[keys[i]]);
}
```

But CoffeeScript has its own syntax that calls this function (the `own` keyword).

``` coffeescript for..own..of
obj = a: 'a', b: 'b'
for own key, val of obj
  foo val
```

## Functional Style

### JavaScript

ES5 added the [forEach](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/forEach) function for arrays only.

``` coffeescript forEach
[1..3].forEach (value, index, array) ->
  foo value
```

### Libraries

``` coffeescript Several libraries
arr = [1..3]
obj = a: 'a', b: 'b'

### jQuery ###
$.each arr, (index, value) ->
  foo value
$.each obj, (key, value) ->
  foo value
$(arr).each (index, value) ->
  foo value
$(obj).each (key, value) ->
  foo value

### Underscore.js or Lo-Dash (alias: forEach) ###
_.each arr, (value, index, arr) ->
  foo value
_.each obj, (value, key, obj) ->
  foo value
_(arr).each (value, index, arr) ->
  foo value
_(obj).each (value, key, obj) ->
  foo value
```

### CoffeeScript Comprehensions

Some people may care that function calls add a lot of overhead, others may argue that functions are always worse than a more idiomatic approach, if available. The more idiomatic approach that CoffeeScript offers is comprehensions, that is basically the traditional control structures in a postfixed notation.

``` coffeescript Comprehensions
arr = [1..3]
# for
foo arr[i] for i in [0...arr.length]
# for..in
foo i for i in arr

obj = a: 'a', b: 'b'
# for..of
foo val for own key, val of obj

# Bonus tracks: while/until
doSomething() while somethingIsTrue()
doSomething() until somethingIsTrue()
```