// Starta servern
s.boot; // en rad kod körs med <Shift> och <Enter>
// Stop server
s.quit;
// Start oscilloscope
s.scope;

// När servern är igång skickar man över en eller flera synth definitioner till serven.


(

// Läs in ljudfiler här
var birdSound1 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees.wav");
var birdSound2 = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/bird_bees_2.wav");
var windSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/soft_wind.wav");
var stepSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/footstep_snow.wav");
var fireSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/fireplace.wav");
var rainSound = Buffer.read(s, thisProcess.nowExecutingPath.dirname ++ "/rain_on_surface.wav");


// Kod inom parenteser körs med <cmd> och <Enter> på Mac eller <ctrl> och <Enter> i Windows

// Vi vill ha doneAction: 1 för att pausa och inte släppa synten --> blir problem när man väljer en ikon igen i samma körning
SynthDef(\birdSound1, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;

SynthDef(\birdSound2, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;

SynthDef(\windSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;
SynthDef(\stepSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;
SynthDef(\fireSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;
SynthDef(\rainSound, { |out = 0, level = 0, bufnum = 0|
	var sound = PlayBuf.ar(1, bufnum, loop: 1, doneAction: 1);
	var output = sound * level.lag(0.5);
	Out.ar(out, output ! 2);
}).add;
)

(
// Flaggor som håller koll på vädret
~sunFlag = false;
~rainFlag = false;
~snowFlag = false;

// Synthinstansen för temperaturen
~temperatureSynth = Synth.new(\temperatureSynth);
~birdSound1 = Synth.new(\birdSound1);
~birdSound2 = Synth.new(\birdSound2);
~windSound = Synth.new(\windSound);
~stepSound = Synth.new(\stepSound);
~fireSound = Synth.new(\fireSound);
~rainSound = Synth.new(\rainSound);

//  ------------------------------------------------ GUI ------------------------------------------------ //

// En del GUI-grejer
w = Window.new("Thermometer",
	Rect.new(
		20,
		200,
		1024,
		500))
.front;
u = UserView(w, Rect(0, 0, 1024, 500))
.background = Color.hsv(0.31, 0.2, 1, 0.5);
~text = StaticText(u, Rect(874, 20, 160, 60))
.string_(" 10.0 degrees")
.font_(Font("Monaco", 16));
~sunImage = Image.open(thisProcess.nowExecutingPath.dirname +/+ "sun.png").scalesWhenResized_(true).setSize(300, 300);
~sunshine = UserView(u, Rect(700, 120, 300, 300))
.background_(Color.new255(0,0,0,0))
.setBackgroundImage(~sunImage, alpha: 0.5);
~sunButton = Button.new(w,Rect(700,120,300,300))
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~sunFlag) {
		~sunFlag = false;
		~sunshine.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~sunImage, alpha: 0.5);
	} {
		~sunFlag = true;
		~sunshine.background_(Color.new255(0,0,0,25))
		.setBackgroundImage(~sunImage, alpha: 1);
		~rainFlag = false;
		~rain.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~rainImage, alpha: 0.5);
		~snowFlag = false;
		~snow.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~snowImage, alpha: 0.5);
	};
	~sunAction.value;
	~rainAction.value;
	~snowAction.value;
});
~rainImage = Image.open(thisProcess.nowExecutingPath.dirname +/+ "rain.png").scalesWhenResized_(true).setSize(300, 300);
~rain = UserView(u, Rect(360, 120, 300, 300))
.setBackgroundImage(~rainImage, alpha: 0.5);
~rainButton = Button.new(w,Rect(360,120,300,300))
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~rainFlag) {
		~rainFlag = false;
		~rain.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~rainImage, alpha: 0.5);
	} {
		~rainFlag = true;
		~rain.background_(Color.new255(0,0,0,25))
		.setBackgroundImage(~rainImage, alpha: 1);
		~sunFlag = false;
		~sunshine.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~sunImage, alpha: 0.5);
		~snowFlag = false;
		~snow.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~snowImage, alpha: 0.5);
	};
	~sunAction.value;
	~rainAction.value;
	~snowAction.value;
});
~snowImage =  Image.open(thisProcess.nowExecutingPath.dirname +/+ "snow.png").scalesWhenResized_(true).setSize(300, 300);
~snow = UserView(u, Rect(20, 120, 300, 300))
.setBackgroundImage(~snowImage, alpha:0.5);
~snowButton = Button.new(w,Rect(20,120,300,300))
.states_([
	["", Color.black, Color.gray(0,0)]
])
.action_({
	if (~snowFlag) {
		~snowFlag = false;
		~snow.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~snowImage, alpha: 0.5);
	} {
		~snowFlag = true;
		~snow.background_(Color.new255(0,0,0,25))
		.setBackgroundImage(~snowImage, alpha: 1);
		~sunFlag = false;
		~sunshine.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~sunImage, alpha: 0.5);
		~rainFlag = false;
		~rain.background_(Color.new255(0,0,0,0))
		.setBackgroundImage(~rainImage, alpha: 0.5);
	};
	~sunAction.value;
	~rainAction.value;
	~snowAction.value;
});
~slider = Slider(u, Rect(20, 20, 840, 60))
.value_(0.5);
//  ----------------------------------------------------------------------------------------------- //



// -------------------------|||||-------------------------
// --------------- Här nedan börjar det roliga -----------
// -------------------------|||||-------------------------

// När slidern klickas spelas ljudet från temperatursynthen upp
~slider.mouseDownAction = {



};
~slider.mouseUpAction = {
	~birdSound1.set(\level, 0);
    ~windSound.set(\level, 0);

};

// Följande funktioner ropas på när de olika väderförhållandena väljs
~sunAction = {
	if (~sunFlag) {
		("Sun").postln;

	} {
		(" noSun").postln;
		~birdSound1.set(\level, 0);
		~windSound.set(\level, 0);
	};
};
~rainAction = {
	if (~rainFlag) {
		("rain").postln;
	} {
		("no rain").postln;
	};
};
~snowAction = {
	if (~snowFlag) {
		("snow").postln;
	} {
	("no snow").postln;
	};
};

// Följande funktion körs när slidern flyttas på
~slider.action_({ arg obj;
	var hue, string; // två variabler för GUIt
    var temperature = linlin(obj.value, 0, 1, -20, 40).round(0.1); // Slider value mapped to temperature range

    // Check sunFlag before adjusting levels
	if (~sunFlag) {
		if(temperature > 20){
			~birdSound1.set(\level, temperature);
			~windSound.set(\level, 0);
		};
		if(temperature <= 20){
			~birdSound1.set(\level, 0);
			~windSound.set(\level, temperature);
		};
	};

	// Följande justerar bakgrundsfärgen i GUIt
	hue = linlin(temperature, -20, 40, 0.6, 0.1);
	if (temperature >= 0) {
		string = "" + temperature + "degrees";
	} {
		string = temperature + "degrees";
	};
	~text.string_(string);
	u.background_(Color.hsv(hue, 0.2, 1, 0.5));

});


// Följande stänger fönstret när processen stängs
CmdPeriod.doOnce({
	w.free;
	w.close;
});

)