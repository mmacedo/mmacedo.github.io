---
layout: post
title: F# Coding Dojo
date: 2011-12-21 01:23
comments: true
categories: [ "F#", ".NET", "Coding Dojo" ]
---

I am an active member of a [.NET user group](http://bludotnet.com.br) in [the city I live](http://en.wikipedia.org/wiki/Blumenau). We have monthly meetings that usually combine a lecture followed by an one hour [coding dojo](http://code.joejag.com/2009/the-coding-dojo/). August this year we had our monthly meeting and I spoke for an hour or so about F# and then challenged the other participants to translate to F# a small problem already codified with C#.

<!--more-->


## Presentation

My presentation was mostly based on the book [Real-World Functional Programming with Examples in F# And C#](http://www.shelfari.com/books/4472689/Real-World-Functional-Programming-With-Examples-in-F-and-C-) and [presentations and slides](http://www.infoq.com/search.action?queryString=F%23&searchOrder=relevance&search=F%23) from Don Syme - the creator, and Tomas Petricek - the author of the book aforementioned. I prepared a handful of tiny code samples to demonstrate from the basic syntax to web development. The presentation was optimized not to sell, but to teach as much as possible of F# in less than a hour for C# developers. I thought "Does it have lots of awesome features worth talking about? Sure, but let's concentrate on what the audience will need to know to start coding when I am finished."


### Results

People don't like what they don't know, and functional programming suffer from not being the mainstream paradigm for enterprise solutions. When I started my presentation, functional programming had already been on the spotlight for decades, and developers had acquired all kinds of assumptions. Discussion went free and when it finally stopped, the tempo of a crash course had become slide skimming.


## Coding Dojo

The idea was to take a small problem in C# and try to translate it to F# during a [Randori Dojo](http://code.joejag.com/2009/the-coding-dojo/). The group consisted of mostly C# developers with almost no background in functional programming. The problem required special thought on how to design the problem and make available the tools in some way that could countermeasure the lack of experience.


### Preparation

Regardless of how much I like Poker there are programmers that never played or are not sure of the rules. The first handout was a printed list with nice visual hints and descriptions of the Poker hands. The second handout was a concise and specially made cheat sheet of the F# syntax commented in the natural language of the members (Brazilian Portuguese). The third handout was not printed, it was the C# code I clean coded and commented, even though it sounds contradictory. I navigated and explained every class and method.
The fourth asset the team had was myself. Devoided of eidetic memories, it would be impossible to get work done fluently in a foreign language you just learned. My work as self appointed specialist was to help people express their intents in a way the compiler understands.


### Results

One hour was just too little for this sort of experiment, we couldn't get past two data structures. The reason is that writing proficiency is usually associated with a specific tool and programming proficiency is very tightly coupled to the style or paradigm. The best intents couldn't speed us much more than that. I had the task to empathize to the F# compiler for my group while I hadn't used some features we needed. The result was myself being demoted to a dark corner hiding full of shame and the search engine taking over as specialist.


## Conclusions

Learning and teaching are always fun, as is coding dojos. However next time I organize a lecture plus coding dojo in a programming language the audience doesn't feel at home, I might reevaluate some assumptions and choices I made for a even better new language coding dojo experience:

* It is absolutely necessary at least one guy practiced a lot that language before the coding dojo.
* There must be enough time for people to get used to the syntax and tools before they are productive.
* There is no room for the paradigmatic or marketing discussion, it must be replaced for a full pragmatic experience of the language that will be used for the coding dojo.


## Output

- **Poker handout**: I got the more visually pleasant I found through the search engine and that didn't have written descriptions.
- **F# Cheat Sheet**: It was optimized for Potuguese and the problem at hand, so not so awesome for general consumption.
- **Slides**: It was a rewrite of existing English language slides and optimized for the problem at hand, also not great for general consumption. Yet, by the group request it is available in portuguese on the [group site](http://www.bludotnet.com.br/2011/08/ata-da-reuniao-introducao-ao-f-e-coding-dojo/).
- **Dojo output**: We didn't produce quite enough output to be useful.
- **Post-dojo output**: I promised the group to send the problem solved. It is available with identifiers in Portuguese on the [group site](http://www.bludotnet.com.br/2011/08/ata-da-reuniao-introducao-ao-f-e-coding-dojo/) and also published in English on [GitHub](https://github.com/mmacedo/dojo-2011-08-poker).