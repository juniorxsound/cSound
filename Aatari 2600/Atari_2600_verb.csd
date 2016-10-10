Bit Shift Register Synthesis

by Jacob Joaquin
www.thumbuki.com

Modified Sept 2010 by Jean-Luc Sinclair
Modified Sept 2016 by Or Fleisher juniorxsound



<CsoundSynthesizer>
<CsInstruments>
sr     = 30000
kr     = 30000
ksmps  = 1
nchnls = 1

/* Normalize audio signal to a range of -1.0 to 1.0 */
0dbfs = 1
garvbsig  init      0    /* global "a" variable initialized to 0 */


/**
 * Bit Shift Register Synth
 *
 * p4 Division of clock. Range 1 - 32.
 */
instr 1
	/* P-field from score */
	idiv = int(p4)  /* Integer division of clock. Range 1 - 32. */
	itab = p5		/* selects the waveform */

	/* Limit clock division to a range between 1 and 32 */
	idiv limit idiv, 1, 32

	/* Convert clock division to frequency */
	ifreq = sr / 16 / idiv /* adds table length to pitch value, longer tables lower pitch

	print ifreq

	/* Oscillator */
	a1 oscil .1, ifreq, itab

	/* Output audio */
	out a1
endin




/**
 * Bit Shift Register Synth with Envelope
 *
 * p4 Starting value of envelope controlling clock division. Range 1 - 32.
 * p5 Ending value of envelope controlling clock division. Range 1 - 32.
 */
instr 2

	/* P-fields from score */
	idur  = p3  /* Duration of instance */
	ienv1 = p4  /* Starting envelope value. Range 1 - 32 */
	ienv2 = p5  /* Ending envelope value. Range 1 - 32 */
	itab	= p6	/* selects the waveform */


	/* Limit envelope end points to a range between 1 and 32 */
	ienv1 limit ienv1, 1, 32
	ienv2 limit ienv2, 1, 32

	/* Envelope to control the clock divider */
	kline line ienv1, idur, ienv2

	/* The original atari 2600 clock uses integers to divide the clock.
	 * Thus, the envelope is quantized from a continuous signal to a
	 * signal composed of whole numbers.
	 */
	kline = int(kline)

	/* Convert clock division to frequency */
	kfreq = sr / 16 / kline

	/* Oscillator */
	a1 oscil .1, kfreq, itab

	/* Output audio */
	out a1

	garvbsig	=	garvbsig + a1*.05		/* 1 1/10th of the dry signal is sent to the reverb */

endin


instr 99
	/* Simple Csound Reverb */

	irvbtime  =         p4

	asig      reverb    garvbsig,  irvbtime      ; put global sig into reverb

      out      asig
	garvbsig  =         0                        ; then clear it
endin



</CsInstruments>
<CsScore>

/* The register. This table stores a compound pulse wave. */
f 1 0 16 -2 0 0 1 1 0 1 0 0 0 1 1 1 0 1 1 1

/* Try entering your won tables for different sounding results. */
f 2 0 16 -2 1 0 0 1 1 1 1 0 1 0 0 1 1 1 1 0
f 3 0 16 -2 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0
f 4 0 16 -2 0 0 0 0 1 0 0 1 0 1 0 1 0 1 1 0



/* Notes */

t 0 120

i 99	 0	 15	    1
i 2	 1	 .05	    1		30	1

i 1	 2	 1	    31	1
i 1	 +	 .	    30	2
i 1	 +	 .	    29	1
i 1	 +	 .	    28	2
i 1	 +	 .	    27	1
i 1	 +	 .	    26	2
i 1	 +	 .	    25	1
i 1	 +	 .	    24	2

i 2	 10	 .5       1		32	3

s

i 99	 0	 25	    1

i 1	 3.5	 1 	    16	1
i 1	 4	 1	    16	.
i 1	 4.5	 1	    16	.
i 1	 4.75  1	    8		.
i 1	 5.5	 1	    16	.
i 1	 6 	 1	    4		.
i 1  6.5	 1	    16	.
i 1  6.75	 1	    8		.



i 2 	 7.5 	 .5	    1	 	32	1
i 2 	 8	 .8	    32	31	.
i 2 	 8 	 .8	    16	15	.
i 2 	 8.25  .45	    10   	11	.
i 2	 8.25	 .45	    12   	13	.

i 2 	 9 	 .8 	    32	31	.
i 2 	 9	 .8 	    16	15	.
i 2 	 9.25	 .45	    10	11	.
i 2 	 9.25  .45	    12   	13	.

i 2 	 10	 .8	    32	31	.
i 2 	 10 	 .8 	    16	15	.
i 2 	 10.25 .45	    10	11	.
i 2 	 10.25 .45	    12  	13	.

i 2 	 11	 .8	    31	30	.
i 2 	 11 	 .8	    15	14	.
i 2	 11.5	 .5	    1	 	32	.

i 2 	 12	  1	    16   	8	.
i 1 	 13	  1	    8		1
i 1	 13	  1	    16	2

i 2 	 14 	  1	    16   	4	2
i 1	 15	  1	    8		3
i 1	 15	  1	    4		3
e
 </CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>72</x>
 <y>179</y>
 <width>400</width>
 <height>200</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{1412b7eb-7282-432e-9b41-73e06a40597b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
