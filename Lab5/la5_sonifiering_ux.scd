// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.
(

// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

SynthDef(\dataSonification, { arg freq;

	var detuneAmount = 0.02;
	var detune = freq * detuneAmount;
	var sine1 = SinOsc.ar(freq: freq + detune);
	var sine2 = SinOsc.ar(freq: freq - detune);
	var output = sine1 + sine2 / 2;
	output = LPF.ar(output, 900)*0.1;

	Out.ar(0, {output}!2);
}).add;

SynthDef(\dataLevels, { arg freq;

	var output = LFTri.ar(freq);
	output = output * EnvGen.ar(Env.perc(0.01, 0.01, 0.5, -8), doneAction: 2);

	output = LPF.ar(output, 700);


	Out.ar(0, {output}!2);
}).add;


SynthDef(\errorSonification, { arg midiNote1 = 60, midiNote2 = 65,
	gate = 0, vol = 0.7;

	var sin = SinOsc.ar(rrand(midiNote1, midiNote2).midicps);  // rrand linear distribution in the given range

	var env = Env.perc(0.001, 0.3, 1.7, -2); // (Attack, release, level, curve)
	var out = sin * EnvGen.kr(env, gate, doneAction: 0);

	Out.ar(0, {out * vol}!2);
}).add;

)


(
// Följande registrerar dataSonification synthdefinitionen på servern
~dataSynth = Synth.new(\dataSonification).register;
~dataLevels = Synth.new(\dataLevels).register;

// Följande är en OSC-lyssnare för level-meddelanden
// 0, 1, 2, 3
OSCdef(\levelListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Ta hand om meddelandet om det inte är samma som förra
		if (inputmsg[1].asInteger != ~statusLevel) {
			~statusLevel = inputmsg[1].asInteger;

			if(~statusLevel == 0) {
				//~statusLevel.postln;
			};

			if(~statusLevel == 1) {
				~dataLevels = Synth.new(\dataLevels, [\freq, 440.00]);
				~statusLevel.postln;
			};

			if(~statusLevel == 2) {
				~dataLevels = Synth.new(\dataLevels, [\freq, 523.25]);
				~statusLevel.postln;
			};

			if(~statusLevel == 3){
				~dataLevels = Synth.new(\dataLevels, [\freq, 659.26]);
				~statusLevel.postln;
			};

		};
	};

}, 'level');

// Följande är en OSC-lyssnare för data-meddelanden
OSCdef(\dataListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Ta hand om meddelandet om det inte är samma som förra
		if (inputmsg[1].asInteger != ~currentData) {
			var frequency;
			// Detta plockar ut datavärdet ur meddelandet som ett heltal
			// och sparar i environment-variabeln
			~currentData = inputmsg[1].asInteger;
			// Följande skickar data-nivån (som en int) till en mapp-funktion
			// som returnerar värdet och sparar det i frequency-variabeln
			frequency = ~mapPitch.value(~currentData);
			// Följande skickar värdet, frekvensen, till synthdefinitionen
			~dataSynth.set(\freq, frequency);
		};
	};
}, 'data');

// Följande är en OSC-lyssnare för fel-meddelanden
OSCdef(\errorListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		~errorMessage = inputmsg[1];
		~errorMessage.postln;

		if ('Risk for overheating' == ~errorMessage){
			// C6 (middle)
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\vol, 0.4);
			~errorSynth.set(\gate, 1);
		};

		if ('Zero target null' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 36);// C2
			~errorSynth.set(\midiNote2, 41); // F2
			~errorSynth.set(\vol, 1.5);
			~errorSynth.set(\gate, 1);
		};

		if ('Bipolar capacity low' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 24);// C1
			~errorSynth.set(\midiNote2, 29); // F1
			~errorSynth.set(\vol, 4.3);
			~errorSynth.set(\gate, 1);
		};

		if ('Unstable output' == ~errorMessage){
			~errorSynth = Synth.new(\errorSonification).register;
			~errorSynth.set(\midiNote1, 72);// C5
			~errorSynth.set(\midiNote2, 77); // F5
			~errorSynth.set(\vol, 1.5);
			~errorSynth.set(\gate, 1);
		};

	};
}, 'error');


~mapPitch = { arg freq;
	// Först görs en linjär till linjär mappning av värdet till frekvens (i Hz)
	var frequency = linlin(freq, 0, 300, 220, 880) ;
	// returnerar värdet
	frequency.value;
};

)

// Följande rad kollar vilken lokal address som OSC-lyssnaren använder. Denna måste
// vara samma i båda programmen, så att "monitorGUIt" skickar på rätt address.
NetAddr.localAddr;