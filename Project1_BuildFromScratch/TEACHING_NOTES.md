# Project 0 — Build From Scratch: instructor notes

Twelve steps, about an hour, everything typed by the students. This runs *before*
the supplied sketches. The point is that by the time they open Project 1 and see
80 lines they didn't write, they already know what a loop is and they believe the
rest is more of the same.

Each `StepNN_*` folder is a complete, runnable sketch — your reference, and the
rescue copy when somebody's file stops compiling. Students work in **one** sketch
the whole time and keep editing it. They should not open these folders unless
they're stuck.

## Timing

| Step | What happens | Min |
|---|---|---|
| 1 | One circle | 5 |
| 2 | Color it | 5 |
| 3 | Three circles, by hand | 4 |
| 4 | Give the numbers names | 7 |
| 5 | A row, with a loop | 7 |
| 6 | A grid, nested loops | 8 |
| 7 | Alternating box colors, if/else | 6 |
| 8 | Take the outlines away | 3 |
| 9 | Random colors from a palette | 5 |
| 10 | Random shapes, if/else ladder | 6 |
| 11 | Empty boxes | 3 |
| 12 | Knobs, seed, save, print | 8 |

Steps 5 and 6 are the real content; everything else is scaffolding around them.
If you're running behind, compress 9–11 (they're structurally identical — each
one moves a decision inside the loop) and protect the time for 12, because that's
where they actually make something they like.

## The spine of the sequence

Three ideas, each one set up by the step before it:

1. **Step 3** — a setting like `fill()` stays set until something changes it.
   One `fill()`, three circles, all the same red.
2. **Step 4** — a number can have a name, and `centerX = centerX + 200` changes
   what's in that name. This is the step that makes the loop legible.
3. **Steps 7, 9, 10, 11** — the same move four times: a decision made *outside*
   the loop happens once and applies to everything; move it *inside* and every box
   decides for itself. Alternating colors, then random colors, then shapes, then
   whether to draw at all.

Say the third one at step 7. Let them notice it at step 9. By step 10 ask them
where the new line goes before showing them — most will get it.

**Step 7 is also where `if` arrives, and it arrives with a rule rather than with
dice.** Even columns get one color, odd columns the other, so the picture is the
same every run and they can check it against the code by eye. Randomness only
shows up in step 9, once `if` is familiar. The payoff is in the step 7 TRY block:
changing `column % 2` to `(column + row) % 2` turns stripes into a checkerboard,
which is worth letting them discover rather than explaining.

## Steps 3 and 4 are supposed to be tedious

Don't rush them. Step 3 makes them type three near-identical `ellipse` lines.
Step 4 shows that every extra circle costs two more lines, always the same two.
Then step 5 writes those two lines once.

If you hand them the loop before they've felt the repetition, it's just more
syntax. The boredom is the motivation, and it's the only one you get for free.

## Why `x = x + 200` matters more than it looks

Step 4 spends real time on it, and it's worth protecting. `=` meaning "becomes"
rather than "is equal to" is the single most common source of early confusion,
and `column++` in step 5 is the same idea in disguise. Students who've written
`x = x + 200` by hand read the loop counter correctly; students who haven't tend
to think the loop is magic.

It also pays off at step 7, where `column % 2 == 0` arrives and the difference
between `=` and `==` suddenly carries weight.

## Variable names

Everything is spelled out: `numberOfColumns`, `numberOfRows`, `boxWidth`,
`boxHeight`, `sizeRatio`, `whichColor`, `whichShape`. No single letters at all —
positions are `centerX` and `centerY`, since `ellipse()` measures from the
middle.

Two names to avoid if a student invents their own: **`size`** and
**`width`/`height`**. `size` is a built-in function and the Processing editor
colors it as one, which undercuts the "type the colored lines" convention.
`width` and `height` are live variables holding the canvas dimensions —
*reading* them is exactly what Steps 5 onward do, but assigning to them compiles
and then quietly breaks the sketch.

## Expected errors, in the order you'll meet them

**Missing semicolon.** Processing highlights the line *after* the real problem.
Teach this once, early, and point at it every time rather than fixing it.

**Unmatched brace** once nested loops appear in step 6. Teach Ctrl-T / Cmd-T
(auto-format) — if the indentation comes out looking wrong, the braces are wrong,
and the shape of the code tells you where.

**`=` instead of `==`** in step 7. Says something about incompatible types.

**Nothing appears.** Almost always `background()` written *after* the shapes, or
a `fill()` the same color as the paper.

**Squares in the wrong place** in step 7 if `rectMode(CENTER)` is missed —
everything shifts down and right by half a cell. Visually obvious, easy fix.

**`polygon()` typed inside `setup()`** — functions must sit outside. The error
mentions an unexpected token. One of the few worth just fixing for them.

## Discussion beats

- **Step 2.** What color is `(12, 200, 190)`? Nobody can say. This is why
  designers use prepared palettes, and why step 7 hands them hex codes.
- **Step 4.** One name, changed once, moves all three circles. Ask what happens
  in a 48-circle version.
- **Step 6.** Every screen they've ever looked at is a loop inside a loop.
- **Step 7.** The picture is the same every run. Ask how they could check the
  code is right just by looking at it — then step 8 takes that away.
- **Step 8.** The only step that deletes rather than adds. The columns merge into
  stripes once the outlines go — ask why before explaining it.
- **Step 9.** Press Play five times. Which one is "the" artwork? If the program
  makes infinite pictures, what did they make — the picture, or the machine?
- **Step 11.** Some random layouts look deliberate. Nobody deliberated.

## Set-up details

Canvas is **600 × 800**, and from Step 5 onward the layout is derived from
`width` and `height` rather than typed in. The default 6 columns and 8 rows give
exactly 100 × 100 boxes, so the arithmetic stays doable in their heads, and
nothing can run off the page when they change the counts.

One consequence worth knowing: `width / numberOfColumns` is integer division,
since both are `int`. Every common count divides 600 cleanly (3, 4, 5, 6, 8, 10,
12, 20), but 7 columns gives 85 instead of 85.71 and leaves 5px unused at the
right edge. Worst case among sensible values is about 12px. It is invisible in
practice, and fixing it would cost a `(float)` cast this early.

For printing, use `p` for the PDF. It's vector, so 600 × 800 prints sharp at any
paper size. The PNG from `s` is screen resolution and is for their phone.

## Handing off to the supplied projects

Three things carry straight over, worth saying out loud when you open Project 1:

- the nested loop over a grid is *exactly* Project 1 (Ordered Chaos)
- `cos()` and `sin()` inside their `polygon()` function are the same two
  functions that build the sunflower in Project 3
- `randomSeed()` and the save keys work identically in every sketch today

Project 1 is then a short conversation: it's their grid, with the position and
angle nudged by a random amount that grows down the page.
