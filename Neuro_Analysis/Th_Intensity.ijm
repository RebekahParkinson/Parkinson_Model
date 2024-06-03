Threshold = 270

//n.b. SingleChannelOnly; Z-stackImages; ROI mask predefined

run("Duplicate...", "title=Striatum")
run("Clear Outside", "stack")
run("Duplicate...", "title=StriatumROI")
run("Duplicate...", "title=StriatumThreshold");
setBackgroundColor(0, 0, 0);
run("Clear Outside");
setMinAndMax(0, 433);
setAutoThreshold("Default dark no-reset");
setThreshold(Threshold, 65535, "raw");
setOption("BlackBackground", true);
run("Despeckle");
run("Create Selection");
run("Copy");
selectWindow("StriatumROI");
run("Paste");
run("Measure");