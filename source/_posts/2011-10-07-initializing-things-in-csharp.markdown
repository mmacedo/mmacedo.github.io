---
layout: post
title: "Initializing things in C#"
date: 2011-10-07 18:11
comments: true
categories: [ "C#" ]
---

The C# team have introduced some nifty syntax sugars since C# 1.0. Among these new features are some to declare anonymous methods and delegates and initializers for objects and collections. They are are there for a while now and still are relatively unknown or misunderstood by the majority of C# programmers.

I will try and clarify them a bit.

<!--more-->

### Introduction

Some features that are added to the C# language are there to take advantage of enhancements made to the .NET. The best example I could think is [.NET Generics](http://en.wikipedia.org/wiki/Generic_programming): the .NET team made the runtime more awesome for us and the C# team adapted the language for us to enjoy the awesomeness of type-safety in .NET Generics. However the .NET runtime hasn’t been modified with such a big change since .NET 2.0 and yet the C# language changed a lot. Most of the changes in the C# language are just [syntax sugar](http://en.wikipedia.org/wiki/Syntactic_sugar). This means that the C# team identify common operations coded in C# and create a nicer and more succint syntax to do the same thing, therefore reducing greatly the amount of [boilerplate code](http://en.wikipedia.org/wiki/Boilerplate_code).


### Anonymous functions and Lambdas

With C#, as in Java, there was no such things as inline functions and every callable block of code should be member of a class. As for VS2005 (C# 2.0, .NET 2.0), this is still true for .NET, but not for the C# language that provided a syntax sugar to abstract that notion: anonymous methods.

For the examples below we will use a dummy calculator that will be posted only once, since it won’t change in my experiments:

``` csharp
public delegate double BinaryOperation(double x, double y);

public static class Calculator
{
    public static double Calculate(double x, double y, BinaryOperation op)
    {
        return op(x, y);
    }
}
```

Now let’s do something with delegates and events. To demonstrate delegates we are using the delegate BinaryOperation we just defined that accepts two doubles and returns a double. To demonstrate events we are using AppDomain’s UnhandledException event.

``` csharp C# 1
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException +=
        new UnhandledExceptionEventHandler(d_UnhandledException);

    var addOperation = new BinaryOperation(Add);
    var result = Calculator.Calculate(5.0d, 4.0d, addOperation);
    Console.WriteLine(result);
}

void d_UnhandledException(object sender, UnhandledExceptionEventArgs e)
{
    Console.WriteLine("Ouch!");
}

double Add(double x, double y)
{
    return x + y;
}
```

``` csharp C# 2 (using method group conversion)
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException += d_UnhandledException;

    var result = Calculator.Calculate(5.0d, 4.0d, Add);
    Console.WriteLine(result);
}

void d_UnhandledException(object sender, UnhandledExceptionEventArgs e)
{
    Console.WriteLine("Ouch!");
}

double Add(double x, double y)
{
    return x + y;
}
```

``` csharp C# 2 (using anonymous methods)
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException += delegate(object sender,
                                     UnhandledExceptionEventArgs e)
    {
        Console.WriteLine("Ouch!");
    };

    var result = Calculator.Calculate(5.0d, 4.0d, delegate(double x,
                                                           double y)
    {
        return x + y;
    });
    Console.WriteLine(result);
}
```

They felt they were done selling VS2005 and then they launched VS2008 (C# 3.0). C# 3.0 was the sweetest of all versions, a lot of boilerplate code was removed with more than a handful of useful syntax sugars. The coolest of them is lambda, but the unusual mathematical name and awful big amount of noise in the internet about expression trees made a lot of people think lambda wasn’t just a syntax sugar, but a fancy super-complex super-dynamic .NET feature.

First, let’s clarify what lambda is really about: a more succint syntax to declare functions inline. This is very close to the original definition in mathematics and it is the definition of how it make your daily C# routine much more sweet.

``` csharp C# 3 (using lambda)
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException += (object sender,
                             UnhandledExceptionEventArgs e) =>
    {
        Console.WriteLine("Ouch!");
    };

    var result = Calculator.Calculate(5.0d, 4.0d, (double x,
                                                   double y) =>
    {
        return x + y;
    });
    Console.WriteLine(result);
}
```

``` csharp C# 3 (using lambda and type inference)
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException += (sender, e) =>
    {
        Console.WriteLine("Ouch!");
    };

    var result = Calculator.Calculate(5.0d, 4.0d, (x, y) =>
    {
        return x + y;
    });
    Console.WriteLine(result);
}
```

``` csharp C# 3 (using lambda inlined and type inference)
public void DoStuff()
{
    var d = AppDomain.CurrentDomain;
    d.UnhandledException += (sender, e) => Console.WriteLine("Ouch!");

    var result = Calculator.Calculate(5.0d, 4.0d, (x, y) => x + y);
    Console.WriteLine(result);
}
```

Every one of the examples compile and are IL-equivalent. Code very similar that do the same thing will be generated for each one by the C# compiler. If you are not using the last one, I ask you: why not?

Before we move to the next topic, it’s worth noting that this very same syntax may be used for another purpose that is scary and overrated: expression tree. Expression trees looks like inline functions, but they are not checked at compile time. Linq To Objects expects inline functions (either of Action or Func delegate types) as it will execute code on collections, while Linq To Sql expect expression trees (of Expression delegate type) that it won’t execute, but instead it will try to generate code (SQL) by parsing yours (C#).


### Anonymous types and Object Initializers

This is something in C# that is as misunderstood as it is useful. It was not there in first versions of C# and both features came in the same batch to ease coding with LINQ. The key part that not everyone get is that they are actually two different things, for different purposes. Yet we will use the same code and transition from regular code to object initializers and to anonymous types explaining how and why you would use each one.

For the examples below we will have declared two classes (please excuse the meaningless names):

``` csharp
class C1
{
    public int P1 { get; set; }
}

class C2
{

    public int P1 { get; set; }
    public C1 P2 { get; set; }
}
```

We want initialize a instance of C2 class, so we write the following code:

``` csharp C# 1
var a = new C1();
a.P1 = 5;

var b = new C2();
b.P1 = 4;
b.P2 = a;

Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

``` csharp C# 3 (using object initializer)
var a = new C1() { P1 = 5 };
var b = new C2() { P1 = 4, P2 = a };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

``` csharp C# 3 (using object initializer)
var a = new C1 { P1 = 5 };
var b = new C2 { P1 = 4, P2 = a };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

``` csharp C# 3 (using object initializer)
var b = new C2 { P1 = 4, P2 = new C1 { P1 = 5 } };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

``` csharp C# 3 (using object initializer)
var b = new C2 { P1 = 4, P2 = { P1 = 5 } };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

It is amazing how much boilerplate code we got rid of. Up to this point every version I presented do exactly the same thing. So again, if you are not using the last one: why not?

It is such a common misconception that we are creating anonymous types in that code, but I can assure you that we are not. We did define those classes back then, remember? So let’s undo that and use anonymous types instead.

First thing you remove the code where you declared C1 and C2 classes. Now your initialization code doesn’t work because you specified a name for the class. The version for C# 1 cannot be converted to anonymous types because you need to specify a property upon initialization. Let’s start fixing our code to compile with anonymous types.

``` csharp C# 3 (using anonymous types)
var a = new { P1 = 5 };
var b = new { P1 = 4, P2 = a };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

``` csharp C# 3 (using anonymous types)
var b = new { P1 = 4, P2 = new { P1 = 5 } };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, P2:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.P2.P1);
```

The code above does not instantiate any specific class, but the one it will generate and that you won’t have access. The only thing you can do with those objects is use its properties and discard it after the method ends. It is sometimes more practical not to declare types for something that you will use just once in a method, for example in a LINQ query. Any other use of the anonymous objects is not advisable, please consider it wisely and do not overuse it.

Now for the sake of knowledge let’s try a slightly different different:

``` csharp C# 3 (using anonymous types and property name inference)
var n = 5;
var a = new { P1 = n };
var b = new { P1 = 4, a };
Console.WriteLine("&#x7b;&#x7b; P1:{0}, a:&#x7b;&#x7b; P1:{1} }} }}", b.P1, b.a.P1);
```

In the above code I did not specify the name of the property to assign the variable therefore the variable name was assigned as the name of the property. This may reduces a bunch of code when using anonymous types as well as the readability. This alternative syntax does not work for object initializers.


### Collection Initializers

It is not unusual to declare collections adding itens one by one. If you are doing it then you probably could replace that with a more object oriented approach. You could do that with if’s and enum’s, but you probably won’t do for every one of them. In C# 1 e 2 they probably didn’t realize the pain it would be to initialize collections item by item. Older C# versions already had initializers for arrays only. Let’s see how you would split a string by low case vowels removing empty entries:

``` csharp C# 1
const string s = "This is a string with vowels!";
char[] separators = new char[5];
separators[0] = 'a';
separators[1] = 'e';
separators[2] = 'i';
separators[3] = 'o';
separators[4] = 'u';
var newString = s.Split(separators, StringSplitOptions.RemoveEmptyEntries);
Console.WriteLine(string.Join(", ", newString));
```

``` csharp C# 1 (using array initializer)
const string s = "This is a string with vowels!";
char[] separators = new char[5] { 'a', 'e', 'i', 'o', 'u' };
var newString = s.Split(separators, StringSplitOptions.RemoveEmptyEntries);
Console.WriteLine(string.Join(", ", newString));
```

``` csharp C# 1 (using array initializer)
const string s = "This is a string with vowels!";
char[] separators = { 'a', 'e', 'i', 'o', 'u' };
var newString = s.Split(separators, StringSplitOptions.RemoveEmptyEntries);
Console.WriteLine(string.Join(", ", newString));
```

``` csharp C# 1 (using array initializer)
const string s = "This is a string with vowels!";
var newString = s.Split(new char[] { 'a', 'e', 'i', 'o', 'u' },
                        StringSplitOptions.RemoveEmptyEntries);
Console.WriteLine(string.Join(", ", newString));
```

``` csharp C# 3 (using array initializer and type inference)
const string s = "This is a string with vowels!";
var newString = s.Split(new[] { 'a', 'e', 'i', 'o', 'u' },
                        StringSplitOptions.RemoveEmptyEntries);
Console.WriteLine(string.Join(", ", newString));
```

This example is somewhat limited because it explore just what you can do to initialize arrays, but since then you can use the same syntax to initialize any other collecion type. A type is initializable through this syntax if it has an Add method. A generic list has an Add method with one parameter, while a generic dictionary has and Add method with two parameters. Let’s see how to initialize both.

``` csharp C# 1
Dictionary<int, int> a = new Dictionary<int, int>();
a.Add(1, 2);
a.Add(2, 4);
List<int> b = new List<int>();
b.Add(1);
b.Add(2);
```

``` csharp C# 3 (using collection initializer)
Dictionary<int, int> a = new Dictionary<int, int>() { { 1, 2 }, { 2, 4 } };
List<int> b = new List<int>() { 1, 2 };
```

``` csharp C# 3 (using collection initializer)
Dictionary<int, int> a = new Dictionary<int, int> { { 1, 2 }, { 2, 4 } };
List<int> b = new List<int> { 1, 2 };
```


### Conclusion

It is very important to identify when you are using a core feature or a syntax sugar, so you can know where to use what. Much more important than writing speed, syntax sugars improve readability without compromise. Syntax sugars make the life of the nexy programmer easier, so [remember](http://www.codinghorror.com/blog/2008/06/coding-for-violent-psychopaths.html): use them!