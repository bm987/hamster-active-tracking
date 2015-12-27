# hamster-active-tracking
Active Time Tracking CLI interface for use with Project Hamster GNOME Time Tracker database

## What it does

This is a simple terminal interface that repeatedly asks you what you
are doing at a predefined time interval.

It provides autocomplete for your existing time tracking codes in the
Hamster database.

If you do not respond within a certain amount of time, it assumes you
are doing nothing and modifies your Hamster database as such.

If you are doing the same thing you were doing the last time you
answered, simply press ENTER.

## Why?

If it's one of those days where you're multi-tasking across dozens of
different tasks, time tracking is very difficult.  Remembering to
switch tasks is hard.  Going back and altering history after you've
forgotten is even harder.  This approach looks at what you are doing
every X minutes (for me, X is 5) and bases the time tracking on that.
You don't have to *remember* to do anything.  You just have to respond
to the beep.  And unless you've switched tasks, responding is a single
keypress.

## What's needed

Hamster Time Tracker, obviously.  https://github.com/projecthamster/hamster

## installing

git clone this repo.

    chmod 755 *.sh

Edit the preferences in `active-tracking.sh`.

Make two sound folders:

	 mkdir sound1
	 mkdir sound2

Put some WAV files in the two folders.  Google free wav sound effects or make your own with `arecord`.
	 
Run `active-tracking.sh`.
