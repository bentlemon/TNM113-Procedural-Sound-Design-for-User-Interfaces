// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

SynthDef(\sampleLjusOG, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 1,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 0,
	);

   var output = sound * 0.5;

	Out.ar(0, [output, output]);
}).add;


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

	  var outputBPF = BPF.ar(in: sound, freq: cutoffFreq, mul: 1.0, add: 0.0) * volumeMod;
	  var outputRLPF = RLPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.0, add: 0.0) * volumeMod;

	// Byt variabel i hl för ändring av output
   var output = outputBPF * outputRLPF;

	Out.ar(0, [output, output]);
}).add;

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
	var outputRLPF = RLPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.0, add: 0.0) * volumeMod;

	// Byt variabel i hl för ändring av output
   var output = outputBPF * outputRLPF;

	Out.ar(0, [output, output]);
}).add;
)

// Klientside skript
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

var soundStart = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Start.wav");
var soundMellan = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Mellan_2.wav");
var soundLjus = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Ljus.wav");
var soundMork= Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/Mörk_3.wav");

Server.default.record;

fork({
	0.1.wait;
	~samplePlayer = Synth.new(\sampleLjusOG, [\bufnum, soundLjus]);
	// Startljud - Molly

	// Mellan
	6.wait;
	/*~samplePlayer = Synth.new(\sampleMellan, [\bufnum, soundMellan]);
	~samplePlayer.set(\rateMod, 1.1);
	~samplePlayer.set(\volumeMod, 18);
	~samplePlayer.set(\cutoffFreq, 600);
	~samplePlayer.set(\rq_value, 0.8); */
	//3.wait;
	// Ljus
	~samplePlayer = Synth.new(\sampleLjus, [\bufnum, soundLjus]);
	~samplePlayer.set(\rateMod, 1);
	~samplePlayer.set(\volumeMod, 15);
	~samplePlayer.set(\cutoffFreq, 900);
	~samplePlayer.set(\rq_value, 2);
	2.wait;

});
)