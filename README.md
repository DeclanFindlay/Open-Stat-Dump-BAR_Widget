# Open-Stat-Dump-BAR_Widget 

This is a Beyond All Reason GUI widget that
displays system stats in-game (NOT THE MENU/LOBBY).
It consumes the output from the Open-Stat-Dump program,
which can be found here:
[Open-Stat-Dump](https://github.com/DeclanFindlay/Open-Stat-Dump) 
Make sure to download and build it before using this widget.
Open-Stat-Dump will need to be running to get your system stats for this widget.

Beyond All Reason can be found and downloaded here:
[Beyond All Reason](https://www.beyondallreason.info/download)

The Beyond All Reason repo can be found here:
[Beyond All Reason GitHub repository](https://github.com/beyond-all-reason/Beyond-All-Reason)

# How to use Open-Stat-Dump-BAR_Widget 

Simply place the gui_stats_widget.lua file in:
C:\Users\<YOUR_USER_NAME>\AppData\Local\Programs\Beyond-All-Reason\data\LuaUI\Widgets\
You will need to create the Widgets folder if it does not already exist.

The game engine will read the file automatically from there.

# IMPORTANT 

You will need to download and build Open-Stat-Dump first; it is a separate program.
This BAR_Widget can't get your system stats by itself. It simply reads
and displays the output from Open-Stat-Dump, which you can find here:
[Open-Stat-Dump](https://github.com/DeclanFindlay/Open-Stat-Dump) 

You will need to manually set the GPU type for your system.
```bash
GPU TYPES -----
local GpuNvidia = "GpuNvidia"
local GpuIntel = "GpuIntel"
local GpuAmd = "GpuAmd"
GPU TYPES -----
```

## Find this code in gui_stats_widget.lua:
```bash
-- change to your GPU type here 
GetMainGpuTemp(GpuNvidia) .. -- <------
```
Note that it is currently configured for an Nvidia GPU.

## Open-Stat-Dump setup:

Make sure to set the Open-Stat-Dump output location to the same location
as the gui_stats_widget.lua file, and select the .lua file output option in Open-Stat-Dump.
You also need to set the output file name to data for gui_stats_widget.lua to see it,
and set the GPU and CPU options to true. The rest can be set to false.

## Widget location adjustments:

You may need to adjust the panel coordinates to change the panel location on your screen.
For example:
``` bash
local panel = {
    x1 = 1375,
    y1 = 990,
    x2 = 1550,
    y2 = 1078,
    round = 6
}
```
It is currently set to fit on a 1920 x 1080 monitor. You should see it around the top right.
<p>
    <img src="images/widget_location.png" width="600">
</p>

Also make sure the widget is actually enabled in-game. For example:
<p>
    <img src="images/check_widget_enabled.png" width="600">
</p>

# License 

Open-Stat-Dump-BAR_Widget is under the MIT License. Check the License file for more information.
