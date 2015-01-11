# Tipster

This is the prework assignment for codepath.  It is a tip calculating app.

Time spent: 4-6hours, two week break, 4-6hours.

Completed user stories:

 * [x] Required: Can calculate tips! (functionality from video)
 * [x] Required: Has a settings view that allows user to set default tip percentage
 * [x] Optional: Improved UI
 * [x] Optional: Saves bill amount (and tip percentage) for 3hrs
 
Notes:

I choose not to do the remaining two optional stories because they conflicted with my design/UI choices.  The app has a handwriting on paper look and feel, and that look and feel doesn't have an obvious light/dark theme.  I considered chalk on chalkboard, but felt that was silly for a bill/tip calculation, and decided against it.  The currency text inputs format themselves with a prefixed "$" and a decimal in the appropriate place as the user types.  Reimplementing that functionality to support leading and trailing currency signs was something I didn't feel like doing.

I added some additional features -- mostly UI features -- that I wanted.  The most salient of which is that all the numeric values shown are editable.  The constraint that 

    total_amount = check_amount + check_amount * tip_percentage
is used to calculate the remaining three values if the user changes one of them.  Other features include 

* Decimal-less numeric input.  The user enters a string of digits only, and they are interpreted as a two-decimal value.  You can still backspace, edit in the middle of the string, etc.  Percentage values are similar: they're rendered back including a percent sign.
* One decimal tip.  If the user enters a tip amount that does not round to a "0" first decimal place, then a first decimal place on the tip_percentage will be shown (this is kind of an easter egg)
* More and Less buttons.  These buttons increment the tip up and down.  In the case that the tip percentage includes decimals, less and more move to the nearest integer (not the same as rounding).
* Blanked values do not change.  If inputs are selected for editing (which clears them) but are not edited, they retain their original value.  They can be zero'ed by entering "0" after selecting them.
* Editing ends after two seconds of inactive editing.  Touching elsewhere on the screen seems obtuse.  If an input is selected for editing (but not edited), it will stay open indefinitely.  If it is selected, and edited, it will close editing after two seconds of inactivity.
* Setting the default tip amount sets the tip amount.  But, visiting the settings page without setting the default tip amount does not set the tip amount.  The directions in the assignment seem to suggest a setup that would always set the tip amount to equal the default tip amount after visiting the settings page.
* Initial app start sets a bill amount of "$10.00" to help illustrate to a new user how the UI works.  Subsequent starts will begins with the previous bill amount (if within 3hrs of last usage) or with "0.00" (if more than 3hrs since last usage).
* Leaving a view (navigating two and from settings, minimizing and restoring the app) saves inputs that are being edited.

Walkthrough of all user stories:

![Video Walkthrough](codepath-video-1.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

