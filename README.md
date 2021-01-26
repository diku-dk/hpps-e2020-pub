# High Performance Programming and Systems (HPPS)

## Overall structure

HPPS takes place in block 2.  The teaching activities are based on the
idea of [flipped
classroom](https://en.wikipedia.org/wiki/Flipped_classroom), where
the lectures are shorter and available as self-study videos, and 
the lecture time is instead used to solve and discuss problems.

Since we are teaching remotely this year, we have two kinds of
teaching sessions: **labs** and **exercise sessions**.  You will be
assigned **videos** and **reading**.

The videos are available in advance, and must be viewed before
attending the labs. The videos stay available throughout the course
so you are free to (re-)view them whenever it suits you.

In the **labs** we will focus on solving concrete problems in small
virtual groups (or physically, as the pandemic and KU permits). The
problems are usually related to the mandatory assignments. After each
sub-problem we will gather and discuss the challenges, pitfalls and
strategies for the problem.

As the exam will be a written exam, the **exercise sessions** will be
focused on solving problems similar to those that will be used in the
exam.  **The exercises for each session are in the [course
outline](https://github.com/diku-dk/hpps-e2020-pub/raw/master/course_outline_student.pdf)**.

## Course overview

We have compiled an overview of the course in the 
[**course outline**](https://github.com/diku-dk/hpps-e2020-pub/raw/master/course_outline_student.pdf)
document, which we will update throughout the course.

If you are in doubt of what to read, watch, or write, the answer
should be in the course outline document.

## Textbook

The textbooks are as follows:

* [Computer Systems: A Programmer's Perspective, 3rd edition](https://csapp.cs.cmu.edu/)

* [Modern C](https://modernc.gforge.inria.fr/) ([CC-licensed PDF](https://gforge.inria.fr/frs/download.php/latestfile/5298/ModernC.pdf))

* [HPPS course notes](notes.pdf) - **these will be updated as the
  course progresses, so make sure to regularly check that you have
  the newest version**

### Videos

The authors of the CS:APP textbook [have made videos available of their
lectures](https://www.youtube.com/playlist?list=PLmBgoRqEQCWy58EIwLSWwMPfkwLOLRM5R).
Note that these lectures are from a classic systems programming
course, with a different focus (and much longer length) than HPPS.
However, they may still be worth watching.

## Schedule

The **labs** take place on

* Tuesday 10:15-12:00 (online)

* Thursday 13:15-15:00 (Lille-UP1 at DIKU, technically 04-1-22)

The **exercises** take place on

* Thursday 15:15-17:00

The exercises are split along the four *hold*, in the following rooms
and TAs:

* **Hold 01 (DatØK):** 1-0-14 (DIKU), Georgios
* **Hold 02 (DatØK):** 1-0-34 (DIKU), Laurent
* **Hold 03 (ML):** A111 (HCØ), Albert
* **Hold 04 (ML):** 1-0-30 (DIKU), Tor

The Tuesday labs are entirely online, and for the Thursday labs you
can decide whether to show up physically or participate online.

The theoretical exercises on Thursday are physical, but will also make
an effort to have teaching resources accessible on the Discord server
for those who prefer to participate virtually.

## Discord

Virtual labs take place on [this Discord
server](https://discord.com/channels/768764206383366185/) ([invite
link](https://discord.gg/KdXMA3v)).  Note that teachers and TAs are
only expected to respond during normal class hours.

The Discord server contains voice channels called *group rooms*.
These are intended for interactive help during labs and exercises.
Simply enter a vacant group room and (hopefully) a teacher or TA will
join and help you out (write a message in one of the text channels if
you've been overlooked).  You can also share your screen (maybe only
when using the standalone Discord app), if necessary.  When you are
done getting help, please leave the room to make it available for
others.

## Zoom

https://ucph-ku.zoom.us/j/63242906073

This Zoom room will be used for the first introductory lab on 17/11.
It is not clear whether it will be used after that, but we may decide
to do more mass lectures.

## Assignments

There are 4 assignment in total during the course with deadline
roughly every week and a half.

The assignments will be graded with points from 0 to 4 and it is not
possible to re-hand-in any of the assignments.

Assignments are made to be solved in groups of preferably three
students, but groups of two active students will also do. We strongly
encourage you not to work alone. Groups cannot be larger than three
students. Each group must make their own solutions and cannot share
implementations and report with other. You may however discuss
material and ideas.

## Study café

On Friday 13:00-15:00 you will be able to get help with the
assignments at the study café.

You will be able to get help on Discord and offline, although the
precise physical location is still undecided.

## Exam qualification

To qualify for the exam you are required to achieve at least 50% of
the total number of points in the four assignments (that is, 8 points
at minimum). You also need to get *at least* one point pr. assignment.

It is also important to note, that the main purpose of the assignments
are not to prepare you for the exam; that is what the exercise classes
are for. The assignments will focus on larger implementations and the
practical learning goals of the course. Some questions in the exam
will relate to the assignments, but qualifying of the exam (and even
fully solving the assignments) will not be enough preparation to pass
the exam. You need to make the exercises and the best way is to be
active in the exercise classes.

## Languages

All written material will be in **English**.

Most oral teaching will be in **Danish** or **English**, depending on
the specific teacher or TA.

You will be mainly be programming in **C** and **Python**.

## Software

You will be using a Unix command line and Unix tools for much of the
course.  [See the Unix software guide.](unix.md)

See also [this guide on the GDB
debugger](http://beej.us/guide/bggdb/), which is a very useful tool
for debugging C programs.

If you prefer an IDE see the [VS Code installation and setup guide](VSCode.md).

## People

The teachers are

* Kenneth Skovhede (<skovhede@nbi.ku.dk>)
* Troels Henriksen (<athas@sigkill.dk>)

The TAs are

* Georgios Garidis (<dpv246@alumni.ku.dk>) (Hold 01)

* Laurent Lindpointner (<xrw514@alumni.ku.dk>) (Hold 02)

* Albert Alonso de la Fuente (<ckz831@alumni.ku.dk>) (Hold 03)

* Tor Skovsgaard (<vtj997@alumni.ku.dk>) Hold (04)

## Exam format

The exam will take the form of a 72-hour take-home exam with two
parts:

* A **theoretical part** that will test your non-coding knowledge of
  the course curriculum, and will be very similar to the exercises
  handed out at the Thursday labs.

* A **practical part** that will test your ability to write parallel
  systems-level code.  This part will most strongly resemble the
  contents of assignment 4.

You are not expected to work full-time for all three days.  We have
not decided on an estimated workload yet, but the idea behind the
72-hour exam format is to *minimise the consequences* of overlaps with
another exam.  (We will still try to minimise overlaps of course, but
it looks like many of you are taking a concurrent four-day exam, so it
cannot be avoided entirely.)

### Time and place

The exam will take place online and run from **08:00 on the 28th to
16:00 on the 30th of January** (note that the 30th is a Saturday).
This is to avoid conflicts with other exams (specifically the ML
course, which has promised to examinate all HPPS students prior to the
28th).
