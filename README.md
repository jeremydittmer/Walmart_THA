# Walmart take-home assignment
Walmart Mobile Engineering app assignment:

#### Screen 1:
* First screen should contain a List of all the products returned by the Service call.
* The list should support Lazy Loading. When scrolled to the bottom of the list, start lazy loading next page of products and append it to the list.

#### Screen 2:
* Second screen should display details of the product.

### Notes:
+ Data is lazy loaded from Walmart API one page at a time (30 items)
  - Note that the [Walmart API documentation](https://walmartlabs-test.appspot.com/) specifies that one of the required parameters is pageNumber where in fact, this parameter specifies the absolute index of the first item in the page.  The code reflects this actual usage.
+ The project includes mock data so that it can work without a connection to the API.  The use of mock data can be turned on and off using the USE_MOCK_DATA constant in "WalmartAPIManager.h".  Using the mock data includes an artificial delay so that asynchronous loading can be tested.
+ The API response includes some instances of the Unicode replacement character (�).  I considered establishing a set of rules for guessing which characters were missing (", ', and ° were a few likely candidates) but making reliable rules would be quite difficult and I further concluded that the correct response to this situation would be to address the root of the problem by communicating with the owner of the API.  In the current implementation, these characters are simply deleted.  This creates some visual artifacts but it is an improvement over seeing many instances of ���.
+ There is some error handling for bad API responses, JSON parsing errors, etc.  More could be done to ensure that all potential errors are caught and that the user is informed appropriately.
+ Images are individually loaded in the background to keep the UI responsive.  When an image is received, the tableview is updated with that image if the item is visible.
+ The short and long descriptions are displayed in the detail view as HTML since the text in the JSON response often includes formatting markup.  I specified a font for the HTML text so that it would match the rest of the text in the interface but left the font size and other styling alone since in some cases, those parameters were specified as a part of the response.
+ The detail view may contain a short description or a long description or both.  The UI responds gracefully to these various permutations.
+ Product ist and detail view designs, loading screens, and app icons were modeled after the current Walmart iOS mobile app available on the app store.
+ Auto Layout is used and the app is universal and looks acceptable on iPhones and iPads of all sizes.  Future improvements could be made by customizing some of the sizing of fonts, images, etc. for different size categories and devices.
+ Star reviews are shaded by area rather than by width.  For example, if the average rating is 4.25, one quarter of the _area_ of the fifth star will be shaded rather than shading one quarter of its width.  This allows users to better visually estimate the numerical value of stars.  A more detailed explanation for this and the math behind it is in "StarRatingView.m".
+ Any views that I thought might be reusable are stand-alone classes that can be dropped into other views as desired.
+ I used only code for the UI (no storyboards or xibs) to make a project that could be more easily worked on simultaneously by multiple developers, better behavior with version control, and a personal preference for explicit vs. implicit.
+ Bonuses:
  - I did not use AFNetworking or AlamoFire
  - No products of the 224 in the list have more than one image and the JSON structure does not support multiple images per item so I did not spend time creating a paged carousel in the detail view.
