// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

SynthDef(\samplePlayer, { arg bufnum = 0, rateMod = 1, volumeMod = 1, cutoffFreq = 440, rq_value = 1.0;
    var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum) * rateMod,
		trigger: 1,
		startPos: 0,
		loop: 1,
		doneAction: 0,
	);

	// Lågpassfilter
	//var output = LPF.ar(in: sound, freq: cutoffFreq, mul: 1.0, add: 0.0) * volumeMod;

	// Högpassfilter
	//var output = HPF.ar(in: sound, freq: cutoffFreq, mul: 1.0, add: 0.0) * volumeMod;

	// Resonans filter
	//var output = RLPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.0, add: 0.0) * volumeMod;

	var output = BPF.ar(in: sound, freq: cutoffFreq, rq: rq_value, mul: 1.0, add: 0.0) * volumeMod;

   //var output = sound * volumeMod;

	Out.ar(0, output);
}).add;

)



// Klientside skript
(
// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

var soundSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sound.wav");

~samplePlayer = Synth.new(\samplePlayer, [\bufnum, soundSample]);
~samplePlayer.set(\rateMod, 1);//.lag(0.05); // oklart
~samplePlayer.set(\volumeMod, 1.5);
~samplePlayer.set(\cutoffFreq, 900);
~samplePlayer.set(\rq_value, 0.8);
)