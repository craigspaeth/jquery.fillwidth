1. Style the elements to have images be lining up next to each other removing the default ul and 
   li paddings & styles.
2. Go through each li and calculate the groups of lis that have the best potential to fill the 
   width of the container with the least amount of adjustment. Then store these groups as 
   objects in memory, and stop using the DOM.
3. Iterate through these row objects run a set of adjustment calculation methods 
   (resizeLandscapesBy(), resizeRowHeightBy(), adjustMarginsBy(), etc) in order of the 
   user's specification.
4. Clean anything up by either brute force reducing the remaining width of list items in each row. 
   Or brute force increasing the width of each item to fit any space remaining due to rounding off.
5. Finally update the DOM by iterating through all of the in memory row objects and applying the 
   new widths.

## Important notes

This is meant to keep a consistent height, so we should be focusing on adjusting width of lis.

As soon as we don't need to use the DOM stop. Read the DOM for dimensions and then pass over 
control to calculations.

We're assuming all of the images have loaded, but this will often not be the case. To counter this 
we can provide a method that either defers fillwidth from happening until everything is loaded. Or 
allow the user to pass an array of aspectRatios like so

[
  1.777
  0.24
  etc
]