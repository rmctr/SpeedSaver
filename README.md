![Banner](banner.jpeg)
# SpeedSaver:  Save your phone and battery.

## What is SpeedSaver? 😮

SpeedSaver is a _Magisk module_ for Qualcomm SoC-based Android phones and its aim is to improve the speed and battery.

#### Disclaimer:
This Magisk module is provided "as is," without warranties of any kind. Use at your own risk; the developers are not liable for any issues or damage.  That said, the module is developed with good intentions and is not intended to cause any harm (unlike some Magisk modules that have surfaced lately, which included malware).  We strongly suggest you inspect the source code before installing our module.  DMCA and distribution notices at the bottom of this page.

## How does it work? 🤖
The module performs SQLite optimization, disables various GMS services, tweaks the kernel for improved latency, trims your partitions (depending on what the kernel permits) -- and keeps running in the background indefinitely to change the CPU priority of GMS services, logging, etc.

## To keep in mind
The module disables some Google services that run in the background on your phone.  If a feature that you use stops working, simply uninstalling the module should make it work again.

Note that it disables Android Rescue Party.  The reason for this is that the "Rescue Party" is more like a "Party Killer," because it is infamous for factory resetting your device on bootloops.  We disabled this.

After install, it is highly recommended to remove the contents of /data/dalvik-cache, reboot, and run "pm compile -a -f -m everything-profile" in the terminal.

## Authors 🤓
The module is developed by Noah Y. and Xaiphon, and it includes code by Draco (tytydraco) called KTweak under the BSD 2-Clause "Simplified" license, for which we thank him.  We also thank DethByte64 for inspiring the way of setting processes' mice levels.

## Support 🆘
Open a [discussion](https://github.com/rmctr/SpeedSaver/discussions) or send an email to noahy@riseup.net.

## Issues/bug reports 🐛 
Open an [issue](https://github.com/rmctr/SpeedSaver/issues) with a description of the issue or bug.

## DMCA notice 
If you have any DMCA-related concerns regarding this repository or its releases, please contact us directly at noahy@riseup.net. We take all copyright matters seriously and will address any valid complaints promptly. We are committed to complying with legal requirements and resolving issues in a fair and timely manner.

## Distribution notice
The official source for this project is our Github repository at https://github.com/rmctr/SpeedSaver. We are not responsible for any distributions of the files outside of this platform. Users are encouraged to download the files directly from our GitHub repository to ensure they have access to important disclaimers and DMCA information, and to be ensured that the files are not tampered with by third-parties. 
