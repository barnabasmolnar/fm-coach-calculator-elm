# Football Manager 2022 Coach Calculator

In [Football Manager 2022](https://www.footballmanager.com/games/football-manager-2022), coaches have several attributes that determine how good they are at coaching any one of the 10 distinct categories that exist within the game.

In FM, coaches are rated on a 5 star system.

This application will show ratings for each category upon inputting the coach's attributes.

**A live version of the app can be found here:**

https://fm22-coach-calculator.netlify.app/

Make sure to sign some proper coaches for your backroom staff, fellow managers!

## Formulas

Should you wish to make your own app or even just an excel sheet, it's fairly easy to get an idea of what the formula is for each category by inspecting the `Formula.elm` file.

Basically, they are just a bunch of weighted sums with results in the 15-300 range.

A coach with a final sum of >=270 for a given category is truly a 5 star coach in every sense of the word.

A sum of >=240 will net you 4.5 stars, >=210 4 stars, and so on.

Star ratings, then, are assigned in increments of 30.