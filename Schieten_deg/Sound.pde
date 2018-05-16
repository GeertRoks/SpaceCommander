class Sound {
  
  //create new variables of ugen-types
  Oscil sound; // oscilator
  Summer sum; //summer -> sum multiple inputs to one output
  Line envelope; // envelope generator, moves from one value to another in a certain time.
 
  
  Sound(float freq) {
    sound = new Oscil(freq, 0.2, Waves.SINE); // create new Oscilator (frequency, amplitude, waveform)
    
    envelope = new Line(2, 0.5, 0); //create new line-generator (time, start-value, stop-value)
    sum = new Summer(); // create new summer)
    
    envelope.patch(sound.amplitude); //patch the envelope output to the carrier amplitude
    envelope.activate(); //trigger the envelope to start.
    
    sound.patch(sum); // patch the carrier oscilator to the summer
    sum.patch(out); // patch the summer through the filter to the output.
  }
  
  boolean ending() {
    return envelope.isAtEnd(); // check if the envelope is ready
  }
  
  void clearPatch() {
    sum.unpatch(out);// disconnect the moog from the output. and thus kill the all audio-signals in this object. 
  }
}