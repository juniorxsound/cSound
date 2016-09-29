<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
//Initialize the script settings
sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1
//Instrument 1
instr 1
  kVar  line    p4, p3, p6

  kTrans linseg p6, p7, p8, p9, -2

  aL, aR diskin p5, kTrans, 3, 4, 0, 32
    outs  aL, aR
endin
//Instrument 2
instr 2
    aL, aR diskin p5, 5, 0, 1, 0, 32
      outs  aL, aR
endin
//Instrument 3
instr 3
ktimewarp line 0, p3, 2.7
kresample init .1
ibeg = 0
iwsize = 4410
irandw = 882
itimemode = 1
ioverlap = p4

asig sndwarp .5, ktimewarp, kresample, 1, ibeg, iwsize, irandw, ioverlap, 2, itimemode
asig = asig * 0.01
arev reverb asig, 5
     outs arev, arev

endin
</CsInstruments>
<CsScore>
//Kick
f1 0   1024 10  1

//Splash Rhytmic Sound
; p1  p2  p3    p4    p5              p6    p7    p8    p9
i 2   0   48    440   "splash.wav"
//Splash Transpose Effects
; p1  p2  p3    p4    p5              p6    p7    p8    p9
i 1   0   4    440   "splash.wav"     100   2     5     10
i 1   7   4    440   .                50    4     10    5
i 1   14  4    440   .                4     4     40    2.5
i 1   20  4    440   .                100   2     5     10
i 1   27  4    440   .                100   2     5     10
i 1   34  4    440   .                50    4     10    5
i 1   41  4    440   .                4     4     40    2.5
i 1   48  4    440   .                100   2     5     100

f 1 0 131072 1 "solo_1.wav" 0 0 0	; audio file
f 2 0 1024 9 0.5 1 0		; half of a sine wave

i 3 0 48 24

e
</CsScore>
</CsoundSynthesizer>
