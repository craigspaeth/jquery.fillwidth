describe "jQuery.fillwidth", ->
  
  beforeEach ->
    @$fixture = $("
    <ul id='fixture' style='width: 400px'>
      <li><img src='fixtures/1.jpeg' style='width: 100px; height=90px'/></li>
      <li><img src='fixtures/1.jpeg' style='width: 200px; height=90px'/></li>
      <li><img src='fixtures/1.jpeg' style='width: 300px; height=90px'/></li>
      <li><img src='fixtures/1.jpeg' style='width: 400px; height=90px'/></li>
    </ul>
    ")
    $('body').append @$fixture
    domLoaded = false
    $ => domLoaded = true
    waitsFor -> domLoaded
  
  afterEach ->
    @$fixture.remove()
  
  describe 'initial styling', ->
    
    it 'removes the list-style, makes margin and padding 0', ->
      @$fixture.fillwidth('initialStyling')
      expect(@$fixture.attr('style')).toEqual(
        "width: 400px; list-style: none outside none; padding: 0px; margin: 0px;"
      )
    
    it 'floats the children lis left', ->
      @$fixture.fillwidth('initialStyling')
      expect(@$fixture.children('li').attr('style')).toEqual(
        "float: left;"
      )
      
    it 'makes the images have a max-width 100% and display block', ->
      @$fixture.fillwidth('initialStyling')
      expect(@$fixture.children('li').children('img').attr('style')).toEqual(
        "width: 100px; display: block; max-width: 100%;"
      )
      
  describe 'breakUpIntoRows', ->
    
    beforeEach ->
      @$fixture.fillwidth('initialStyling')
    
    it 'given a ul of lis, will break them up into in memory rows depending on the parent width', ->
      expect(@$fixture.fillwidth('breakUpIntoRows')[0].lis.length).toEqual 3
      expect(@$fixture.fillwidth('breakUpIntoRows')[1].lis.length).toEqual 1
      
  describe 'resizeLandscapes', ->
    
    xit 'given an in-memory row will attempt to resize the landscapes down', ->
      @$fixture.fillwidth('initialStyling')
      row = @$fixture.fillwidth('breakUpIntoRows')[0]
      console.log row
      console.log @$fixture.fillwidth('resizeLandscapes', row)
      