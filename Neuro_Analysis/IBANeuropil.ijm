//n.b. Multi Channel; Multi Z-stack; ROI predefined

Threshold = 200

roiManager("reset")
run("Duplicate...", "duplicate");
setBackgroundColor(0, 0, 0)
run("Clear Outside", "stack")
run("Clear Outside")
run("Split Channels");
Neuropil = getImageID() 
run("Duplicate...", "title=Neuropil-1")
run("Duplicate...", "title=Neuropil-2")

setAutoThreshold("Default");
setThreshold(0, 65535);
setThreshold(0, Threshold);
setOption("BlackBackground", true);
run("Make Binary")
run("Invert")
run("Analyze Particles...", "size=S-L circularity=0-1.0 add show")

selectWindow("Neuropil-1")
roiManager("combine")
run("Clear Outside")
 
selectWindow("Neuropil-2")

run("Measure");
roiManager("reset")
selectWindow("Neuropil-1")
run("Select None");
	percentage = 90.00; 
	nBins = 256; 
	resetMinAndMax(); 
	getHistogram(values, counts, nBins); 
		// find culmulative sum 
		nPixels = 0; 
		for (i = 0; i<counts.length; i++) 
  			nPixels += counts[i]; 
			nBelowThreshold = nPixels * percentage / 100; 
		sum = 0; 
		for (i = 0; i<counts.length; i++) { 
  			sum = sum + counts[i]; 
  		if (sum >= nBelowThreshold) { 
    		setThreshold(values[0], values[i]); 
    		print(values[0]+"-"+values[i]+": "+sum/nPixels*100+"%"); 
    		i = 99999999;//break 
  		} 
	} 
waitForUser

run("Convert to Mask"); 
run("Invert")
run("Remove Outliers...", "radius=0.75 threshold=100 which=Dark");
run("Create Selection");
run("Measure");

run("Convert to Mask"); 
run("Remove Outliers...", "radius=0.75 threshold=50 which=Dark");
run("Create Selection");
run("Measure");

selectWindow("Results");
String.copyResults();