(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  describe("jQuery.fillwidth", function() {
    beforeEach(function() {
      var domLoaded;
      this.$fixture = $("    <ul id='fixture' style='width: 400px'>      <li><img src='fixtures/1.jpeg' style='width: 100px; height=90px'/></li>      <li><img src='fixtures/1.jpeg' style='width: 200px; height=90px'/></li>      <li><img src='fixtures/1.jpeg' style='width: 300px; height=90px'/></li>      <li><img src='fixtures/1.jpeg' style='width: 400px; height=90px'/></li>    </ul>    ");
      $('body').append(this.$fixture);
      domLoaded = false;
      $(__bind(function() {
        return domLoaded = true;
      }, this));
      return waitsFor(function() {
        return domLoaded;
      });
    });
    afterEach(function() {
      return this.$fixture.remove();
    });
    describe('initial styling', function() {
      it('removes the list-style, makes margin and padding 0', function() {
        this.$fixture.fillwidth('initialStyling');
        return expect(this.$fixture.attr('style')).toEqual("width: 400px; list-style: none outside none; padding: 0px; margin: 0px;");
      });
      it('floats the children lis left', function() {
        this.$fixture.fillwidth('initialStyling');
        return expect(this.$fixture.children('li').attr('style')).toEqual("float: left;");
      });
      return it('makes the images have a max-width 100% and display block', function() {
        this.$fixture.fillwidth('initialStyling');
        return expect(this.$fixture.children('li').children('img').attr('style')).toEqual("width: 100px; display: block; max-width: 100%;");
      });
    });
    describe('breakUpIntoRows', function() {
      beforeEach(function() {
        return this.$fixture.fillwidth('initialStyling');
      });
      return it('given a ul of lis, will break them up into in memory rows depending on the parent width', function() {
        expect(this.$fixture.fillwidth('breakUpIntoRows')[0].lis.length).toEqual(3);
        return expect(this.$fixture.fillwidth('breakUpIntoRows')[1].lis.length).toEqual(1);
      });
    });
    describe('resizeLandscapes', function() {
      return xit('given an in-memory row will attempt to resize the landscapes down', function() {
        return this.$fixture.fillwidth('initialStyling');
      });
    });
    describe('setRowHeight', function() {
      return xit('it makes sure all of the lis are the same height', function() {});
    });
    describe('considerMargins', function() {
      return xit('reduces the entire row by the sum of its margins', function() {});
    });
    describe('removeMargin', function() {
      return xit('sets the last list items margin to 0', function() {});
    });
    return describe('fillLeftoverPixels', function() {
      return xit('extends lis until they fill the remaining pixels', function() {});
    });
  });
}).call(this);
