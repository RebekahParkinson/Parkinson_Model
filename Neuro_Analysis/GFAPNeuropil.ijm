//Prepare image
run("8-bit");

// Apply threshold 
setThreshold(100, 255);
waitForUser("Adjust the threshold if necessary, then click OK.");

// Create binary mask
setOption("BlackBackground", false);
run("Convert to Mask");

// Analyze particles to measure the area
run("Analyze Particles...", "size=0-Infinity display clear summarize");

// Get results from the summary table
totalArea = getResult("Total Area", 0);
particleArea = getResult("Area", 0);

// Calculate the percentage of the area covered by the marker and show result
percentageCovered = (particleArea / totalArea) * 100;
print("Percentage of area covered by GFAP: " + percentageCovered + "%");