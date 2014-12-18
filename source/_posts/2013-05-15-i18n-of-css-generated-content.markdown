---
layout: post
title: I18n of CSS generated content
categories: css less twitter-bootstrap rails
comments: true
---

In the [documentation of Twitter Boostrap 2](http://twitter.github.io/bootstrap/), there is a pretty example box, with a caption on the top-left corner. If you inspect the HTML code, you won't find the caption, it is generated with CSS. It might seem absurd, a violation of the traditional separation of style and content, but there is a way around it.

## Content inside CSS

This is the example box:

![box screen shot](http://i.imgur.com/5swemcI.png?1)

One might be tempted to make a mixin out of it (only relevant CSS displayed for now):

Declaration of the mixin (LESS):

```
.bs-docs-box(@caption) {
  &:after {
    // Echo out a label for the example
    content: @caption;
  }
}
```

Declaration of the CSS class (LESS and ERB):

```
.example {
  .bs-docs-box("<%= translate 'example' %>");
}
```

Usage of the CSS class (HAML):

```
.example
  Vivamus sagittis...
```

The problem with this example is that we have content of the site inside the CSS, instead of the HTML. To be able to use this example with <abbr title="Internationalization">i18n</abbr> we have to serve the CSS as if it was a view, what [can not be done with Rails](http://stackoverflow.com/a/16246891/619510).

## Extracting content to HTML

 If we go read the [CSS _'content'_ specification](http://www.w3.org/TR/CSS2/generate.html#content), we will find that this property accepts `attr(<identifier>)` as a value. This _attr_ function will return the value of a specified attribute from the selected element.

 Now, instead of having a LESS mixin with a caption parameter, we can have only one CSS class:

```
.bs-docs-box:after {
  content: attr(data-caption);
}
```

And use it like this (HAML):

```
.bs-docs-box{'data-caption' => translate('example')}
  Vivamus sagittis...
```

## Extracting it to a view helper on Rails

Declaring a view helper:

```
module ApplicationHelper
  def example
    content_tag :div, 'class'        => 'bs-docs-box',
                      'data-caption' => translate('example') do
      yield
    end
  end
end
```

Using the view helper:

```
= example do
  Vivamus sagittis...
```

## Full code of the box

My best guess of the box LESS code from the static CSS code of the documentation, plus our little improvement:

```
@import "twitter/bootstrap/variables";
@import "twitter/bootstrap/mixins";

// Extracted from http://twitter.github.io/bootstrap/
.bs-docs-box {
  & {
    position: relative;
    margin: 15px 0;
    padding: 39px 19px 14px;
    *padding-top: 19px;
    background-color: @bodyBackground;
    border: 1px solid #ddd;
    .border-radius(@baseBorderRadius);
  }

  &:after {
    // Echo out a label for the example
    content: attr(data-caption);
    position: absolute;
    top: -1px;
    left: -1px;
    padding: 3px 7px;
    font-size: @baseFontSize - 2;
    font-weight: bold;
    background-color: #f5f5f5;
    border: 1px solid #ddd;
    color: #9da0a4;
    .border-radius(@baseBorderRadius 0 @baseBorderRadius 0);
  }
}
```

Credits of finding the solution to [@nzifnab](http://stackoverflow.com/a/16321962/619510).
