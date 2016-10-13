A class examining the use of phasors to read an f-table
<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 1

  instr 1
    //Amplitude var
    iAmp = p4
    //Freq
    iFreq = p5
    //So you can reuse this setup for multipule f-tables via the p6
    iTableLength = p6
    //Which table to use
    iTableNumber = p7

    //Create a phasor (i.e a clock that counts from 0 to 1)
    aPhasor phasor iFreq
    //Devide the phasor by the table length (kind of like defining the step length)
    aScaled = aPhasor * iTableLength
    //Which table to use
    aTable table aScaled, iTableNumber
    //Scale the output by the correct p-Field (p4)
    aOsc = aTable * iAmp
    //Export the thing
    aOsc out

  endin

</CsInstruments>
<CsScore>
//Sine Wave
f 1 0 16384 10 1

i 0 1 1 1 880 16384 1

</CsScore>
</CsoundSynthesizer>
