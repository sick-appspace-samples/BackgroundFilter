local recordedFilePath = 'resources/scandata'

-- Check device capabilities
assert(View, 'View not available, check capability of connected device')
assert(Scan, 'Scan not available, check capability of connected device')
assert( Scan.BackgroundFilter, 'BackgroundFilter not available, check capability of connected device' )
assert( Scan.EchoFilter, 'EchoFilter not available, check capability of connected device' )

-- Create a viewer instance
local scanViewer = View.create('scanViewer')
assert(scanViewer, 'Error: View could not be created')

local pointCloudDecoration = View.PointCloudDecoration.create()
pointCloudDecoration:setPointSize(3)

-- Create the filter
local backgroundFilter = Scan.BackgroundFilter.create()
backgroundFilter:setThreshold(200)
backgroundFilter:setEnabled(false)

local echoFilter = Scan.EchoFilter.create()

-- Create provider. Providing starts automatically with the register call
-- which is found below the callback function
local provider = Scan.Provider.RemoteScanner.create()
assert(provider, 'Scan provider could not be created')

-- Create Player to playback records, which are used here instead of real data
local player = Recording.Player.create()
player:setDataSourceLookupMode('BEST_MATCH')
player:setFileSource( recordedFilePath .. '.sdr.json', recordedFilePath .. '.sdri.json' )

local transformScans = Scan.Transform.create()
local pointCloud = PointCloud.create('INTENSITY') -- PointCloud which contains scans from all 4 layers

local scanNr = 1

-- Callback function to process new scans
--@handleOnNewScan(scan:Scan,sensordata:SensorData)
local function handleOnNewScan(scan)
  local phi = Scan.getPointPhi(scan, 0)

  if scanNr == 400 then
    print('Background Filter is now active')
    backgroundFilter:setEnabled(true)
  end
  -- filter multiple echoe values. background filter only filters first echo.
  scan = echoFilter:filter(scan)
  scan = backgroundFilter:filter(scan)
  -- Only update viewer for all scan layers one time in 0° layer
  if math.abs(phi) < 0.01 then
    scanViewer:addPointCloud(pointCloud, pointCloudDecoration)
    scanViewer:present()
    pointCloud = transformScans:transformToPointCloud(scan)
  else
    local cloudThisScan = transformScans:transformToPointCloud(scan)
    pointCloud = pointCloud:mergeInplace(cloudThisScan)
  end
  scanNr = scanNr + 1
end

local function main()
  provider:register('OnNewScan', handleOnNewScan)
  -- Start the playback of recorded data
  player:start()
end
Script.register('Engine.OnStarted', main)
