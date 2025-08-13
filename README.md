# Synopsis
There are four scripts, one for each knob. I know a monolithic script with parameters would be cleaner.

 - vol-adjust-pa.sh
	 - Used to adjust the volume level of all pulseaudio outputs (sinks).
 - mic-adjust-pa.sh
	 - Used to adjust the level for all pulseaudio inputs (sources).
 - app-adjust-pa.sh
	 - Used to adjust the volume for a specified application in pulseaudio (sink-input).
 - foc-app-adjust-pa.sh
	 - Used to adjust the volume of the current application with focus (sink-input).
	 > **Note:**  (Makes use of xdotools, might be adaptable to wayland using the more modern dotools package.)

# Dependencies
 - pulseaudio (or pipewire-pulse)
 - xdotools 
 - jq
 - sed
 - head

## Usage
 1. Download the scripts and place them someplace memorable. ie: ~/scripts/ or ~/.scripts/ 
 2. chmod +x each script.
 3. You can manually call the script from a shell or immediately enter them into opendeck.
	 ie: ~/.scripts/app-adjust-pa.sh toggle vesktop (This would toggle mute on vesktop if its running)
	 
 4. All scripts except app-adjust take only one parameter:
  "toggle" will toggle mute on/off
  Providing a positive or negative integer will adjust the volume by the amount.
  ie: ~/.scripts/vol-adjust-pa.sh -5
   > **Note:** The above example would decrease the volume by 5% for all audio outputs.

## Configuring OpenDeck

 1. Select a StreamDeck+ from the device drop-down if you have more than one compatible device.
 2. Drag a new "Run Command" action to the desired knob.
 3. For the "Dial down" action provide the script in its full path and the parameter "toggle:
 > **Dial down:** ~/.scripts/foc-app-adjust-pa.sh toggle
 4. For the "Dial rotate" action provide the script in its full path with the parameter %d
 > **Dial rotate:** ~/.scripts/foc-app-adjust-pa.sh %d
 5. The app-adjust-pa.sh requires two parameters, the second being the application name in pulseaudio:
 > **Dial down:** ~/scripts/app-adjust-pa.sh toggle discord
 6. If you want text output on the LCD checkmark "Show on key:"
