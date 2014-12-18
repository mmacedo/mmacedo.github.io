---
layout: post
title: Formatting strings in .NET
categories: c-sharp dot-net
comments: true
---

You may want to format some scalar value as a string, since default ToString functionality is possibly not what you want the user to see. You may want to do some occasional tool or toy console app. Not only these but perhaps any other reason may inspire you to code some string art. With C# there is no string interpolation, but there is a string formatting framework with a reasonable power. Let's see about that.

## String.Format

Most popular languages have something to format strings. In the .NET framework, this functionality is implemented by the String's static method Format. It has a few important properties that are definitely worth noting:

- **Indexed**:  Unlike most format functions, parameters are indexed and therefore need not to be ordered.
- **Untyped**: Unlike C's [printf](http://en.wikipedia.org/wiki/Printf_format_string), it doesn't need to know the parameters types, and instead relies on [subtype polymorphism](http://en.wikipedia.org/wiki/Subtype_polymorphism).
- **Flexible**: It can format the parameters, but the function itself doesn't need to know how to do it, again it relies on polymorphism to do that.

## How it does it?

You might wonder how it prints things if it is not typed. Most basic functionality in converting to String is taken from the ToString instance method of Object, which is the root type for all .NET types. If the object must support custom formatting functionality, it implements the IFormattable interface with a ToString method signature that is both format-aware and locale-aware.


## How would I do it?

No one wants to duplicate this functionality, so everywhere you expose this option to your string inputs you follow some conventions and just delegate String.Format the hard work. The convention signature for a method that exposes String.Format functionality is a string parameter followed by one to three object parameters or a object array in the [variadic](http://en.wikipedia.org/wiki/Variadic_function) form and a return of String, of course. Classic .NET methods that support this convention are:

* [String.Format (static)](http://msdn.microsoft.com/en-us/library/system.string.format.aspx)
* [Console.Write (static)](http://msdn.microsoft.com/en-us/library/system.console.write.aspx), [Console.WriteLine (static)](http://msdn.microsoft.com/en-us/library/system.console.writeline.aspx)
* [TextWriter.Write](http://msdn.microsoft.com/en-us/library/system.io.textwriter.write.aspx), [TextWriter.WriteLine](http://msdn.microsoft.com/en-us/library/fcs6ys85.aspx)
* [StringBuilder.AppendFormat](http://msdn.microsoft.com/en-us/library/system.text.stringbuilder.appendformat.aspx)

A last advice, use it wisely, don't ever duplicate framework functionality. Also don't break the convention, it must work exactly like String.Format, don't add any logic at all and your user will be at home consuming your API.


## How do I use it?

The basic format is with brackets and a zero-based parameter index like the following C# code:

``` csharp
var name = "World";
Console.Write("Hello, {0}!", name);
// Hello, World!
```

To show why indexed is better than ordered:

``` csharp
var name = "World";
var greeting = "Hello,";
Console.Write("<span title='{0}'>{1} {0}!</span> ", name, greeting);
// <span title='World'>Hello, World!</span>
```

What if I need curly brackets in my string?

``` csharp
var statement1 = "var greeting = 'Hello World!';";
var statement2 = "alert(greeting, name);";
var function = @"
function hello(name) &#x7b;&#x7b;
  {0}
  if (name != null && name != '') &#x7b;&#x7b;
    {1}
  }}
}}";
Console.Write(function, statement1, statement2);
// function hello(name) {
//   (...)
// }
```


## What do I need IFormattable for?

As stated before, IFormattable is both locale-aware and format-aware, but the basic formatting we've seen so far is not. Let's see a example on how to use format parameter.

``` csharp
var someNumber = 320320.51d;
Console.WriteLine("Some number: {0}", someNumber);
// Some number: 320320.51
Console.WriteLine("Someone's salary: {0:C} or perhaps {0:0,0.00 USD}", someNumber);
// Someone's salary: $320,320.51 or perhaps 320,320.51 USD
Console.WriteLine("Four decimal places: {0:N4} or {0:0,0.0000}", someNumber);
// Four decimal places: 320,320.5100 or 320,320.5100
Console.WriteLine("Not less than 3, not more than 5: {0:0,0.000##}", someNumber);
// Not less than 3, not more than 5: 320,320.510
Console.WriteLine("Just one decimal place: {0:N1} or {0:0,0.0}", someNumber);
// Just one decimal place: 320,320.5 or 320,320.5
Console.WriteLine("No decimal place or thousand separator: {0:0}", someNumber);
// No decimal place or thousand separator: 320321
Console.WriteLine("Fancy stuff: {0:0.# is >= zero;-0.# is < zero}", -1d);
// Fancy stuff: -1 is < zero
Console.WriteLine("Fancy stuff: {0:0.# is > zero; -0.# is < zero;0.# is zero}", 0d);
// Fancy stuff: 0 is zero
```

You can find everything about [number formatting](http://msdn.microsoft.com/en-us/library/dwhawy9k.aspx) on MSDN.

Of all methods I listed before, only String.Format exposes one extra overload starting with a locale parameter. If you don't feel that you should expose a parameter, you may use a culture configured in your library or just use the current culture (for that, just use String.Format without that parameter).


## Just that?

I haven't told you the coolest thing about formatting strings yet. As everything else, it comes for free in your custom API if you don't do anything fancy with the string before handing to String.Format. Let's suppose you are in fixed-width font environment like a dummy console app you created to test something or gather some data that isn't worth making a library for. You are probably spending a lot of effort to get it visually pleasant, but you don't need that. You could do just this:

``` csharp
var columns = new[] { "Name", "Memory" };
// get top 3 running processes by memory usage
var data = Process.GetProcesses()
    .Select(p => new object[] { p.ProcessName, p.WorkingSet64 / 1024d / 1024d })
    .OrderByDescending(p=> p[1]).Take(3).ToArray();

// print rows
Console.WriteLine("{0,-20} {1,10}", columns[0], columns[1]);
foreach (var cell in data)
{
    Console.WriteLine("{0,-20} {1,10:0,0.# MB}", cell[0], cell[1]);
}

//Output:
//Name                     Memory
//devenv                 364.6 MB
//opera                  229.4 MB
//svchost                103.3 MB
```


## Further reading

I pointed everything you should know to rock with string formatting. Any doubt on this, consult the [MSDN articles on the subject](http://msdn.microsoft.com/en-us/library/26etazsy.aspx) for more details.
