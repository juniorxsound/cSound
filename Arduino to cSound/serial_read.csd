//A cSound script for reading Arduino values over serial
//Use this to run the script in the terminal
<CsoundSynthesizer>
<CsOptions>
--opcode-lib=serialOpcodes.dylib -odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 500 ; the default krate can be too fast for the arduino to handle
0dbfs = 1

instr 1

	//Start Serial Communication
	iSerialPort	serialBegin	"/dev/cu.usbmodem1421", 9600

	//Read the values into a slower k-rate variable
	kType	serialRead iSerialPort

	if(kType == 49.00000) then
		//do something
	endif

	//Trigger the Tx Arduino


	//Print the serial value on change to the console

endin


</CsInstruments>
<CsScore>
i 1 0 3600
e
</CsScore>
</CsoundSynthesizer>
