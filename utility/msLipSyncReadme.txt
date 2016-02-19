Files
=====
Tool\msLipSync.lua - the main code for the lipSync script
Utility\msLipSyncReadme.txt - this file
Utility\lipSync.txt - bone information for lip sync
Utility\msDialog.lua - dialog utility routines
Utility\msHelper.lua - debugging routines
Utility\msPhonemes.lua - routines for breaking text into phonemes

Installation
============
- Copy msLipSync.lua into the script\tool\ directory of your choice.
- Copy the Utility\*.* files into the script\utility directory
It's recommended that you copy these files to the script directory in your user
content location.

Functionality
=============
The script allows the user to specify a phrase in a dialog box, as well
as a starting and ending frame. It will then create keyframes for the
character, matching the phrase entered by the user. 

Usage 
=====
This video shows the basics of using the script. 
https://www.youtube.com/watch?v=kwfEie-RSe8&list=PLMDdsoe58WVPCRcjRs8RUitA5_fvsBnir

The script will be named LipSync. In order to select the script you
must select either a switch layer, that controls the standard mouth
shapes, or on a bone layer that controls mouth movements. If you are 
not on one of those layers the script will not be enabled. 

Before you select the script you should note the frame where the audio 
starts and ends and the phrase that is being spoken. The script allows 
you to lip Sync any portion of the audio, so as a best practice you 
should lip sync continuous segments of speech.

Once you know the start and end frame of your audio, and the phrase
being spoken, start up the script. A dialog will pop up allowing you 
to enter the Start Frame, End Frame and Text String. It also allows
you to select Phonetic spelling and Debug. 

When you select ok the script will add key frames to the layer you 
have selected. It will not delete existing key frames. 

Intention of the Script
=======================
While the script does an excellent job spacing out phonemes, the
intention is not specifically to get a perfect match. Rather the
intention is to get the proper sequence of phonemes in the correct
order and close to the correct location. You can then tweak the 
speech by dragging key frames as normal. 

Consonants, Vowels and Held Tones
=================================
The script recognizes that, in general, many consonants cannot be held.
For example, in the word, "cat", "c" and "t" cannot really be held a
long time. As a result, those kinds of letters are only given one
frame. Vowels, on the other hand can easily be held for a long time. As
a result the script will assign all the short consonants one frame, 
subtract them from the total number of frames and then divide the 
result by the number of vowels. This creates a phoneme spacing that 
matches the speech in most cases. If your speech has certain sounds
that are held inordinantly long you simply need to list those sounds 
multiple times. For example "the faaat cat" would hold the "a" sound,
in "fat", three times longer than the other vowels in the phrase. The
script also recognizes that certain consonants, like "n" and "m" can
be held, so they act like vowels. 

Non-letters
===========
Punctuation and numbers should not cause the script to crash, but the
symbols will be unrecognized and will, in most cases, result in an 
"etc" phoneme. 

Phonetic or not
===============
The script does a fair job at converting basic English phrases into the
appropriate phonemes, but using phonetic spelling matches the phonemes 
exactly to what you want. You can even use it to match foreign language
by and non-language, just by selecting whatever phonetic symbol you
want. The exact phonetic mapping is given at the end of this file.

Debug 
=====
You can select Debug if something goes wrong in the lip sync. With
Debug selected, statements will be printed to hopefully help fix the
issue. Note, since I do not earn my income from the script I cannot 
support problems that might occur, but hopefully the Debug option can
help if you encounter a problem. 

Switch Layers
=============
If you are using switch layers for lip sync, it needs to have the
standard mouth shapes. It can have other shapes, and they can be in 
any order, but it must have the shapes AI, E, L, FV, etc, MBP, O, U,
WQ, rest. Note that capitalization does matter. 

Bone Layers
===========
If you are using bones to control your mouth, the dialog will show a 
selection box where you will choose the appropriate bone map to use
with your character. You can modify the file Utility\lipSync.txt to 
lip sync any bones controlling you character's speech.

Bone Maps
=========
A bone map tells the script what angles to set for which bones in order
to produce the mouth look you want for any of the standard mouth 
phonemes. You can have any number of bones controlling your mouth. Bone
maps that come with this script include Scarlett (used with Scarlett Riggs),
Bigsby, Dragon, Gorilla, and Gruille.

Creating Your Own Bone Maps
===========================
Creating your own bone maps is easy, but it follows very specific
rules. Failure to follow the rules will cause the script to break.
The easiest way to create a bone map is to copy an existing one and
modify it. You don't add a new file, you just insert another map into
the same file. The format of the map is

mapName numberOfBones
boneName1 boneName2 ... boneNameN
phoneme boneAngle1 boneAngle2 ... boneAngleN

Rules of the Bone Maps
======================
- The last line in the file must be the word "end" 
- mapName and boneNames must be a single word
- the mapName can be anything, but the boneNames must match real bones
in the character
- / is allowed in names, but other characters might cause the script to
break
- capitalization matters for bone names
- you need to include bone angles for each phoneme
- capitalization matters for phoneme names
- bone angles need to be in degrees

A Word of Advice About Creating Your Own Maps
=============================================
Before you create your own bone map, study the ones that come with the
script. Next create a very simple map with a single bone. If a bone map
doesn't seem to work, try to simplify it and test with a very simple
phrase. 

Phonetic Spelling
=================
The following list shows the phonetic letter and the phoneme that will
be created

    a = AI
    b = MBP
    c = etc
    d = etc
    e = E
    f = FV
    g = etc
    h = etc
    i = E
    j = etc
    k = etc
    l = L
    m = MBP
    n = etc
    o = O
    p = MBP
    q = WQ
    r = etc
    s = etc
    t = etc
    u = U
    v = FV
    w = WQ
    x = etc
    y = etc
    z = etc
    A = AI
    E = E
    I = AI
    U = U
    O = O
    R = O
	  - = rest

Notice that in many cases the long and short vowel have the same mouth
phoneme. That just makes it easier to specify the spelling. Notice
also, that you may specify "-" so signify the "rest" mouth position. 