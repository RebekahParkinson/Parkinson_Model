dir = "Define Path"
list = getFileList(dir);
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".nd2")) {
        run("Bio-Formats Importer", "open=[" + dir + list[i] + "] virtual color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        originalTitle = getTitle();
        run("Split Channels");
        for (ch = 2; ch <= 4; ch++) {
            channelTitle = "C" + ch + "-" + originalTitle;
            if (isOpen(channelTitle)) {
                selectWindow(channelTitle);
                run("Duplicate...", "duplicate");
                saveAs("Tiff", dir + "Channel_" + ch + "_" + list[i] + ".tif");
                close(); 
                run("Z Project...", "projection=[Max Intensity]");
                maxProjTitle = getTitle();
                if (isOpen(maxProjTitle)) {
                    selectWindow(maxProjTitle);
                    saveAs("Tiff", dir + "MaxProj_Channel_" + ch + "_" + list[i] + ".tif");
                    close(); 
                }
        	run ("Close All");
            }
        }
    }
}