// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// ------------------- OG INSPELNINGSLJUD ----------------- MOLLY
SynthDef(\sampleMorkOG, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);
	var output = sound * 0.4;

	Out.ar(0, [output, output]);
}).add;

// ------------------- STARTLJUD ----------------- MOLLY
/*SynthDef(\sampleMork, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);

	// Resonans filter - självsvägning vid brytningsfrekvensen
	var outputRLPF = RLPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.5, add: 0.0) * volumeMod;
	var envelope = EnvGen.kr(Env.perc(attackTime: 2.1, releaseTime: 6.0, level: 1.5, curve: 5.0));


	// Byt variabel i hl för ändring av output
	var output = outputRLPF * envelope;

	Out.ar(0, [output, output]);
}).add;
*/

/*
// ------------------- MELLANLJUD -----------------
SynthDef(\sampleMellan, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);

	var outputHPF = HPF.ar(in: sound, freq: cutoffFreq, mul: 1.0, add: 0.0) * volumeMod;

	// Byt variabel i hl för ändring av output
   var output = outputHPF;

	Out.ar(0, [output, output]);
}).add;
*/

/*
// ------------------- LJUSTLJUD -----------------
SynthDef(\sampleLjus, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);

	// rq = relation mellan brytfrekvensen och brandbredd

	// Bandpassfilter - 2dr gradens butterworthfilter
	var outputBPF = BPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.0, add: 0.0) * volumeMod;

	// Byt variabel i hl för ändring av output
   var output = outputBPF;

	Out.ar(0, [output, output]);
}).add;
*/

// ------------------- MÖRKTLJUD ----------------- MOLLY
SynthDef(\sampleMork, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);

	// Envelope with ADSR
	var envelope = EnvGen.kr(Env.perc(attackTime: 0.001, releaseTime: 10.0, level: 1.0, curve: -5.0));

	// Lowpass filter
	var filteredSound = LPF.ar(sound, cutoffFreq);

	var output = (sound * envelope * volumeMod) + (filteredSound * 2.0);

	Out.ar(0, [output, output]);
}).add;

)



// -------------------------------------------------- Klientside skript --------------------------------------------------
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

var soundStart = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Start.wav");
var soundMellan = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Mellan_2.wav");
var soundLjus = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Ljus.wav");
var soundMork= Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Mörk_3.wav");

Server.default.record;

fork({
	1.wait; // Annars kommer UGen buff att klaga
	~samplePlayer = Synth.new(\sampleMorkOG, [\bufnum, soundMork]);
	//10.wait;
	// Startljud - Molly - OK
	/*~samplePlayer = Synth.new(\sampleStart, [\bufnum, soundStart]);
	~samplePlayer.set(\rateMod, 1.0);
	~samplePlayer.set(\volumeMod, 2.5);
	~samplePlayer.set(\cutoffFreq, 440);
	~samplePlayer.set(\rq_value, 0.7); */
	//10.wait; // Väntar 10 sekund
	// Mellan
	/*~samplePlayer = Synth.new(\sampleMellan, [\bufnum, soundMellan]);
	~samplePlayer.set(\rateMod, 1);//.lag(0.05); // oklart
	~samplePlayer.set(\volumeMod, 1.5);
	~samplePlayer.set(\cutoffFreq, 900);
	~samplePlayer.set(\rq_value, 0.8);
	10.wait; */
	// Ljus
	/*~samplePlayer = Synth.new(\sampleLjus, [\bufnum, soundLjus]);
	~samplePlayer.set(\rateMod, 1);//.lag(0.05); // oklart
	~samplePlayer.set(\volumeMod, 1.5);
	~samplePlayer.set(\cutoffFreq, 900);
	~samplePlayer.set(\rq_value, 0.8);*/
	5.wait;
	// Mörkt - Molly
	~samplePlayer = Synth.new(\sampleMork, [\bufnum, soundMork]);
	~samplePlayer.set(\rateMod, 0.3);
	~samplePlayer.set(\volumeMod, 1.0);
	~samplePlayer.set(\cutoffFreq, 200);
	~samplePlayer.set(\rq_value, 0.5);
	1.wait;
});
)