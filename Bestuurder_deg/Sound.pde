class Sound {
  
  Oscil sound;
  Summer sum; 
  Line envelope; 
 
  
  Sound(float freq) {
    sound = new Oscil(freq, 0.2, Waves.SINE); //(frequency, amplitude, waveform)
    
    envelope = new Line(2, 0.5, 0); //(time, start-value, stop-value)
    sum = new Summer(); 
    
    envelope.patch(sound.amplitude);
    envelope.activate();
    
    sound.patch(sum);
    sum.patch(out);
  }
  
  boolean ending() {
    return envelope.isAtEnd();
  }
  
  void clearPatch() {
    sum.unpatch(out);
  }
}