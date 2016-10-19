<CsoundSynthesizer>

<CsOptions>

</CsOptions>
;--opcode-lib=serialOpcodes.dylib -odac
<CsInstruments>
sr = 44100
ksmps = 500 ; the default krate can be too fast for the arduino to handle
0dbfs = 1

instr 1
	//Start Serial Communication
	iSerialPort	serialBegin	"/dev/cu.usbmodem1421", 9600

	//Read the values into a slower k-rate variable
	kRx	serialRead iSerialPort

	//If the serial buffer is empty send the Arduino a what's up byte
	printk 0.5, kRx

endin


</CsInstruments>
<CsScore>
i 1 0 3600
e
</CsScore>
</CsoundSynthesizer>
