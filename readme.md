## BackgroundFilter
Apply background filter on scans read from a file
### Description
The sample shows the effect of the background filter on scans read from a file. Every time a new scan is read from the given resource file, the Lua function "handleOnNewScan" is called. After the first 500 scans, the background filter is set active and uses the next scan to initialize the background. All following scans are filtered using these backgrounds. The data contains scans from an MRS1000 sensor with four layers. The background (initialization and removal) is handled for each layer separately. For the visualization, the scans from all layers are collected into a point cloud and are visualized in a viewer.
### How to Run
Starting this sample is possible either by running the App (F5) or debugging (F7+F10). Output is printed to the console and the transformed point cloud can be seen on the viewer in the web page. The playback stops after the last scan in the file. To replay, the sample must be restarted. To run this sample, a device with AppEngine >= 2.11.0 and AppStudio >= 3.0 is required.
### Implementation
To run with real device data, the scan provider has to be configured accordingly and the playback of the recording should be removed. 
### Topics
Algorithm, Scan, Filtering, Sample, SICK-AppSpace
