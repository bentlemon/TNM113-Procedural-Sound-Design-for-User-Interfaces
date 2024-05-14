// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.

(

// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// Synthdefinitioner som skapar helt procedurella ljud
SynthDef(\chordSynth, { arg bus, freq, gate = 0, level = 0;
	var car, mod, envelope, output;
    car = SinOsc.ar(freq, mul: 0.4);
    mod = SinOsc.ar(freq * 2.99, mul: 0.1);

	car = car * mod;
	envelope = EnvGen.kr(Env.asr(0.01, 0.5, 0.1), gate);
	output =  car * envelope * level.lag(1) * 0.1;
	Out.ar(bus, {output}!2);
}).add;

SynthDef(\trumbonlSample, { arg bus, bufnum = 0, gate = 0, level = 0, volume = 0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: gate,
		startPos: 0,
		loop: 1,
		doneAction: 2
	);
	var output = sound * level.lag(0.2);
	output = output * volume;
	Out.ar(bus, {output}!2);
}).add;


SynthDef(\jazzSample, { arg bus, bufnum = 0, gate = 0, level = 0, volume = 0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: gate,
		startPos: 0,
		loop: 1,
		doneAction: 2
	);
	var output = sound * level;
	output = output * 0.07;
	Out.ar(bus, {output}!2);
}).add;


SynthDef(\drums1Sample, { arg bus, bufnum = 0, gate = 0, level = 0, volume = 0.09;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: gate,
		startPos: 0,
		loop: 1,
		doneAction: 2
	);
	var fadeIn = PfadeIn.new(volume, 0.5);
	var output = sound * level;
	output = output * volume;
	Out.ar(bus, {output}!2);
}).add;

SynthDef(\bassSynth, { arg bus, freq, gate = 0, level = 0, volume = 0;
	var sqrWave = LFPulse.ar(freq: freq / 2, width: 0.5, mul: 0.1);
	var filtered = LPF.ar(sqrWave, 500);
	var envelope = EnvGen.ar(Env.adsr(attackTime: 2, decayTime: 2, sustainLevel: 0.5, releaseTime: 3, peakLevel: 0.5 * level, curve: -6), gate);
	var output = filtered * envelope * volume;
	Out.ar(bus, {output}!2);
}).add;


// Synthdefinitioner som spelar upp ljudsamplingar

SynthDef(\doorbellSamplePlayer, { arg bus, bufnum = 0, t_gate = 0, level = 0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: t_gate,
		startPos: 0,
		loop: 0,
		doneAction: 2
	);
	var output = sound * 0.015 * level;
	Out.ar(bus, {output}!2);
}).add;

SynthDef(\bellSamplePlayer, { arg bus, bufnum = 0, level = 0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 2
	);
	var output = sound * 0.02 * level;
	output = BHiShelf.ar(output, freq: 1000, rs: 0.5, db: 9);
	Out.ar(bus, {output}!2);
}).add;

SynthDef(\tempratureSamplePayer, { arg bus, gate = 0, level = 0, midiNote1 = 60, midiNote2 = 64, midiNote3 = 67;
	var sin = SinOsc.ar(midiNote1.midicps);
	var sin2 = SinOsc.ar(midiNote2.midicps);
	var sin3 = SinOsc.ar(midiNote3.midicps);
	var env = Env.perc(0.01, 0.3, 1, -8); // (Attack, release, level, curve)
	var out = (sin + sin2 + sin3) * EnvGen.kr(env, gate, doneAction: 0);

	Out.ar(0, {out * level}!2);
}).add;

SynthDef(\champSamplerPlayer, {arg bufnum = 0, level = 1.0, trigger = 0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: trigger,
		startPos: 0,
		loop: 0,
		doneAction: 2
	);
	sound = sound * level;

	Out.ar(0, sound);
}).add;

SynthDef(\houseSamplerPlayer, {arg bufnum = 0, level = 1.0;
	var sound = PlayBuf.ar(
		numChannels: 2,
		bufnum: bufnum,
		rate: BufRateScale.kr(bufnum),
		trigger: 1,
		startPos: 0,
		loop: 0,
		doneAction: 2
	);
	sound = sound * level;

	Out.ar(0, sound);
}).add;

// Effects and output
SynthDef(\outputEffects, {arg inputbus, bus;
	var input = In.ar(inputbus, numChannels: 2);
	var reverbed = FreeVerb.ar(in: input, mix: 1, room: 0.5, damp: 0.1, mul: 1.0);

//	var echo = Greyhole.ar(in: input, delayTime: 2.5, damp: 0.5, diff: 0.8, feedback: 0.5);
//	var roomEffects = reverbed + echo;

	var output = input + (reverbed * 0.75);
	Out.ar(bus, output);
}).add;

SynthDef(\outputChannel, {arg inputbus, level = 0.5;
	var output = In.ar(inputbus, numChannels: 2);
	output = output * level;

	Out.ar(0, output);
}).add;

)
// Klientside script
(
var drums1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/drumloop.wav");
var trumbone = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/trombone.wav");
var jazz = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/jazz1.wav");

// Följande registrerar outputEffect synthdefinitionen på servern
~outputChannelBus = Bus.audio(s, numChannels: 2);
~outputChannel = Synth.new(\outputChannel, [\inputbus, ~outputChannelBus.index;]).register;
~outputEffectBus = Bus.audio(s, numChannels: 2);
~outputEffect = Synth.new(\outputEffects, [\inputbus, ~outputEffectBus.index, \bus, ~outputChannelBus.index;]).register;

~drums1Sample = Synth.new(\drums1Sample, [\bufnum , drums1]);
~trumbonlSample = Synth.new(\trumbonlSample, [\bufnum , trumbone]);
~jazzSample = Synth.new(\jazzSample, [\bufnum , jazz]);


//~chordDictionary = Dictionary[0 -> [62, 65, 69], 1 -> [60, 64, 67], 2 -> [67, 71, 74], 3 -> [65, 68, 72]];
// Följande ackord ger en lite mollaktig ackordföljd
// Toner i ackordet 0 = C, Eb, G; 1 = C, D, G; 2 = C, F, G; 3 = D, G, B
//~chordDictionary = Dictionary[0 -> [60, 63, 67], 1 -> [60, 62, 67], 2 -> [60, 65, 67], 3 -> [62, 67, 71]];

~chordNumber = 0;
// Skapa ett dictionary för att stoppa ackordsyntarna i
~chordSynthDictionary = Dictionary.new;
// Fyll dictionaryt med syntarna och skicka med effektbussen
for (0, 2) { arg index;
	~chordSynthDictionary.add(index -> Synth.new(\chordSynth, [\bus, ~outputEffectBus.index;]).register);

};
~chordLevel = 0.25;

// Följande toner funkar till den mollaktiga ackordföljden
// Toner i basen C, C, F, G
//~bassNoteNumbersToUse = [60, 50, 53, 55];

// Registera bassynten på servern och skicka med effektbussen
~bassSynth = Synth.new(\bassSynth, [~outputEffectBus.index;]).register;
~bassLevel = 0;


// Läs in klockljudet, ni får se över sökvägen till de ljud ni använder
~bellSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/bell2.wav");
// Läs in dörrklockljudet
~doorbellSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/doorbell2.wav");

~tempSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/doorbell.wav");

~champSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/champagne.flac");

~houseSample = Buffer.read(s, thisProcess.nowExecutingPath.dirname++"/sounds/house.wav");


// En environmentvariabel som håller koll på antal personer i lobbyn
~numberOfPersons = 0;
// Detta förbereder en rutin som sequencerfunktionen använder senare
~startRoutine.play(AppClock);
~tempoInBPM = 75; // Detta är tempot i slag per minut (beats per minute)
~beatCounter = 1; // Detta är en variabel som håller koll på vilket slag i takten det är
~startFlag = true; // En flagga som används för att starta klockan (en gång) när det första OSC-meddelandet tas emot
~stopflag = false; // En flagga som används när dagen är slut och sedan stoppar uppspelningen
~oldHour = 0; // En variabel som används för att kolla om timmen som kommer via OSC är en ny timme eller inte
~min = 0;
~oldTemp = 0.0;


~sequencingFunction = {
	~tempoClock.schedAbs(0, {
		// Om ~beatCounter är på första slaget, 1, sätt rätt toner till syntarna
		if (~beatCounter == 1) {
			~chordSynthDictionary.size.do{ arg index;
				~chordSynthDictionary.at(index).set(\freq, ~chordDictionary[~chordNumber][index].midicps, \level, ~chordLevel, \gate, 1);

			};
			~bassSynth.set(\freq, ~bassNoteNumbersToUse[~chordNumber].midicps, \level, ~bassLevel, \gate, 1);
		};
		// Räkna sedan upp ~beatCounter
		~beatCounter = ~beatCounter + 1;
		// Om ~beatCounter är 9 har de 8 taktslagen för ackordet gjorts
		// Släpp upp "tangenterna" för syntarna
		if (~beatCounter == 9) {
			~chordSynthDictionary.size.do{ arg index;
				~chordSynthDictionary.at(index).set(\gate, 0);
			};
			~bassSynth.set(\gate, 0);
			// Kolla om ~stopFlag och första ackordet gäller, stoppa då uppspelningen
			if ((~stopflag) && (~chordNumber == 0)) {
				~tempoClock.stop;
			};
			// Räkna upp ~chordNumner så att nästa ackord används
			~chordNumber = ~chordNumber + 1;
			// Det är bara fyra ackord, börja om från första ackordet om det behövs
			if (~chordNumber > 3) {
				~chordNumber = 0;
			};
			// Och återställ ~beatCounter till 1
			~beatCounter = 1;
		};
		0.2; // 1.0 innebär att schedAbs klockas i fjärdedelar av en takt
	});
};

~houseFlag = true;

// Följande är en OSC-lyssnare för tids-meddelanden
OSCdef(\timeListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		// Kolla om ~startFlag är true och i så fall starta klockan och ropa på sequencerfunktionen
		if (~startFlag) {
			~startFlag = false;
			~tempoClock = TempoClock.new(~tempoInBPM/60);
			~sequencingFunction.value();
		};
		// Uppdatera ~hour med inkommande OSC-meddelande
		~hour = inputmsg[1];
		~min = inputmsg[2].asInteger;
		~min.postln;

		// Om det är en ny timme, ropa på ~hourSyncedStuff och uppdatera ~oldHour
		if (~hour != ~oldHour) {
			~hourSyncedStuff.value;
			~oldHour = ~hour;
		};

		if ((~hour >= 20) && (~min > 13) && (~houseFlag)) {
			Synth.new(\houseSamplerPlayer, [\bufnum, ~houseSample;]);
			~houseFlag = false;
		};
	};
}, 'time');
s.record(duration: 5);

// Följande funktion anropas av OSC-lyssnaren som tar emot tidsinformationen
~hourSyncedStuff = {
	switch (~hour,
		8, { // Morning
			// Spela upp klockljudet som markerar de olika tidsdelarna
			//~playbell.value;
			~drums1Sample.set(\gate, 1, \level, 1);
			~chordLevel = 0;

			// Sätt ljudvolymen för de procedurella syntarna, vilken sedan sätts i sequencerfunktionen
			~chordLevel = 0.0;
		},
		11, { // Lunch
			~playbell.value;
			~tempoInBPM = 100;

			~drums1Sample.set(\volume, 0.05);
			~trumbonlSample.set(\gate, 1, \level, 1, \volume, 0.05 );

			~bassLevel = 0.25;
			~chordLevel = 0.0;
		},
		12, { // Lunch
			~playbell.value;
			~tempoInBPM = 100;

			~drums1Sample.set(\volume, 0.008);
			~trumbonlSample.set(\gate, 1, \level, 1, \volume, 0.01);
			~jazzSample.set(\gate, 0, \level, 0);


			~bassLevel = 0.25;
			~chordLevel = 0.0;
		},
		13, { // Afternoon
			~playbell.value;
			~jazzSample.set(\gate, 1, \level, 1, \volume, 0.3);
			~drums1Sample.set(\gate, 0, \level, 0);
			~trumbonlSample.set(\gate, 0, \level, 0);

			~chordLevel = 1;
			~bassLevel = 0.5;

		},
		14, { // Afternoon
			~playbell.value;
			~jazzSample.set(\gate, 1, \level, 1, \volume, 1);
			~drums1Sample.set(\gate, 0, \level, 0);
			~trumbonlSample.set(\gate, 0, \level, 0);
			~bassLevel = 0.5;

		},
		16, { // Afternoon
			~playbell.value;
			~jazzSample.set(\gate, 1, \level, 1, \volume, 2);
			~drums1Sample.set(\gate, 0, \level, 0);
			~trumbonlSample.set(\gate, 0, \level, 0);
			~bassLevel = 0.5;

		},
		17, { // Evening
			~playbell.value;
			~jazzSample.set(\gate, 1, \level, 2);
			~trumbonlSample.set(\gate, 1, \level, 1, \volume, 0.05);
			~chordLevel = 0.25;
			~bassLevel = 0.15;
		},
		20, { // Happy hour --> Champange
			~playbell.value;
			~jazzSample.set(\gate, 0, \level, 0);
			~trumbonlSample.set(\gate, 0, \level, 0, \volume, 0);
			Synth.new(\champSamplerPlayer, [\bufnum, ~champSample, \bus, ~outputEffectBus.index, \level, 1.2, \trigger, 1;]);
		},
		23, { // Closed
			~playbell.value;

			// Sätt stoppflaggan för sequencerfunktionen
			~stopflag = true;
		},
	);
};


// Följande funktion spelar upp klockljudet, eftersom synthdefinitionen har en doneAction på 2 tas den syntinstansen bort från servern när samplingen har spelats upp. Därför kan vi bekvämt skapa en ny instans varje gång vi spelar upp ljudet.
~playbell = {
	Synth.new(\bellSamplePlayer, [\bufnum, ~bellSample, \bus, ~outputEffectBus.index, \level, 0;]);
};


// Följande är en OSC-lyssnare för person-meddelanden. Meddelandet tas emot som en int (inputPerson) och om det värdet är större än ~numberOfPersons ska ett ljud spelas upp. Därefter uppdateras ~numberofPersons. Även denna synthdefinition har en doneAction på 2.
OSCdef(\personListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		var inputPerson = inputmsg[1].asInteger;
		if (inputPerson > ~numberOfPersons) {
			Synth.new(\doorbellSamplePlayer, [\bufnum, ~doorbellSample, \bus, ~outputEffectBus.index, \level, 1;]);
		};
		~numberOfPersons = inputPerson;

	};
}, 'person');


// Följande är en OSC-lyssnare för temperatur-meddelanden. OSC-meddelandet tas emot som en float, och seadan mappas inkommande temperaturvärdet linjärt mot en ljudvolymförändring som är lagt på utgångskanalen och därmed förändrar ljudvolymen på alla syntar som spelar.
OSCdef(\temperatureListener, { arg inputmsg;
	if (inputmsg.size > 1) {
		var inputTemperature = inputmsg[1].asFloat;
		var diffTemp = ~oldTemp - inputTemperature;
		var absDiffTemp = diffTemp.abs;

		// Tempen sänks --> A minor chord
		if(diffTemp >= 0.1){
			Synth.new(\tempratureSamplePayer, [\bus, ~outputEffectBus.index, \level, 0.4, \gate, 1, \midiNote1, 69, \midiNote2, 72, \midiNote3, 76;]);
			~oldTemp = inputTemperature;
		};

		// Tempen ökar --> C major chord
		if(diffTemp < -0.1){
			Synth.new(\tempratureSamplePayer, [\bus, ~outputEffectBus.index, \level, 0.4, \gate, 1;]);
			~oldTemp = inputTemperature;
		};

	};
}, 'temperature');

)