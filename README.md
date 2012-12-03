# jquery.fillwidth

A jQuery plugin that given a `ul` with images inside their `lis` will do some things to line them up
so that everything fits inside their container nice and flush to the edges. Used throughout [Art.sy](http://art.sy) to make rows of images fit inside a fluid container and still stay flush without cropping the images.

![Example Art.sy Screenshot](http://cl.ly/image/2r2m3Z310O2u/fill_width.jpg) 

See the [example](https://github.com/craigspaeth/jquery.fillwidth/blob/master/example/index.html) using [placekitten.com](http://placekitten.com/) for a basic implementation.

## Usage

Create a DOM structure such as

````html
<ul id='fill'>
  <li>
    <img>
  </li>
</ul>
````

Then apply the fillwidth plugin.

````javascript
$('#fill').fillwidth()
````

## Options

jquery.fillwidth takes a number of options you can pass to it's constructor.

### resizeLandscapesBy { Number } (default 200)

Fillwidth will try to reduce images that are landscape (longer in width than height) up to a certain amount of pixels. Change this number to adjust the maximum amount of pixels fillwidth is allowed to reduce landscapes.

![Landscape Reduce Example](http://cl.ly/image/061J3y1g2C2U/Image%202012.12.03%203:27:57%20PM.png)

### resizeRowBy { Number } (default 15)

Fillwidth will try to subtly reduce the entire height of each row up to a certain amount of pixels. Change this number to adjust the maximum amount of pixels fillwidth is allowed to reduce each row by.

![Row Height Reduce Example](http://cl.ly/image/2B3a2127330a/Image%202012.12.03%203:38:41%20PM.png)

### beforeFillWidth { Function }

Pass in a callback before fillwidth does it's magic and tries to line up images

### afterFillWidth { Function }

Pass in a callback right after fillwidth does it's magic and lines up images.

````javascript
$('#fill').fillwidth({
  resizeLandscapesBy: 100,
  resizeRowBy: 40,
  beforeFillWidth: function() {},
  afterFillWidth: function() {}
})
````

## To build

Fillwidth is written in coffeescript and must therefore be compiled before contributing updates.

* Install [node](https://github.com/joyent/node/wiki/Installation)
* Install [coffeescript](http://jashkenas.github.com/coffee-script/) `npm install coffee-script`

````
cake build
````