#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"
#include "gpio.h"
// // Hardware configuration // // Set up nRF24L01 radio on
//SPI bus plus pins 8 & 9
void setup(void);
void loop(void);


RF24 radio(SUNXI_GPI(14), SUNXI_GPI(15), "/dev/spidev2.0"); // // Channel info 
//
const short num_channels = 128;
short values[num_channels]; //

int main(int argv, char** argc)
{
  setup();
  while (1) loop();

  return 0;
}

// Setup //
void setup(void) {
  //
  // Print preamble
  //

  printf("\n\rRF24/examples/scanner/\n\r");
  //
  // Setup and configure rf radio
  //
  radio.begin();
  radio.setAutoAck(false);
  // Get into standby mode
  radio.startListening();
  radio.stopListening();
  // Print out header, high then low digit
  int i = 0;
  while ( i < num_channels )
  {
    printf("%x",i>>4);
    ++i;
  }
  printf("\n\r");
  i = 0;
  while ( i < num_channels )
  {
    printf("%x",i&0xf);
    ++i;
  }
  printf("\n\r");
}
// // Loop //
const short num_reps = 100;

void loop(void) {
  // Clear measurement values
  memset(values,0,num_channels);
  // Scan all channels num_reps times
  int rep_counter = num_reps;
  while (rep_counter--)
  {
    int i = num_channels;
    while (i--)
    {
      // Select this channel
      radio.setChannel(i);
      // Listen for a little
      radio.startListening();
      __usleep(128);
      radio.stopListening();
      // Did we get a carrier?
      if ( radio.testCarrier() )
	++values[i];
    }
  }
  // Print out channel measurements, clamped to a single hex digit
  int i = 0;
  while ( i < num_channels )
  {
    printf("%x",min(0xf,values[i]&0xf));
    ++i;
  }
  printf("\n\r");
}
