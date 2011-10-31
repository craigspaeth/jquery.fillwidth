# jquery.fillwidth

**THIS IS CURRENTLY A WORK IN PROGRESS**

A jQuery plugin that given a `ul` with images inside their `lis` will do some things to line them up so that everything fits inside their container nice and flush to the edges while retaining the integrity of the original images (no cropping or skewing).

## Installation

Simply copy and embed jquery.fillwidth.js into your project.

    <script type="text/javascript" src="jquery.fillwidth.js"></script>
  
## Usage


## To build

* Install [node](https://github.com/joyent/node/wiki/Installation)
* Install [npm](http://npmjs.org/) `curl http://npmjs.org/install.sh | sh`
* Install [coffeescript](http://jashkenas.github.com/coffee-script/) `npm install coffee-script`
* Install [sentry](https://github.com/craigspaeth/sentry) `npm install sentry`

Then simply run the cake command.

````
cake build
````

## Running Tests

Open up `test/SpecRunner.html` in a browser