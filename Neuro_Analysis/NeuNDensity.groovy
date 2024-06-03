import qupath.lib.gui.tools.MeasurementExporter
import qupath.lib.objects.PathCellObject

setImageType('FLUORESCENCE');
setChannelNames(
     'DAPI',
     'TH',
     'MJFr14-ASYN',
)
createSelectAllObject(true);

runPlugin('qupath.imagej.detect.cells.WatershedCellDetection', '{"detectionImage": "DAPI",  "requestedPixelSizeMicrons": 0.5,  "backgroundRadiusMicrons": 8.0,  "medianRadiusMicrons": 0.0,  "sigmaMicrons": 2.0,  "minAreaMicrons": 10.0,  "maxAreaMicrons": 400.0,  "threshold": 10.0,  "watershedPostProcess": true,  "cellExpansionMicrons": 5.0,  "includeNuclei": true,  "smoothBoundaries": true,  "makeMeasurements": true}');

//populate from image channels automate this
runObjectClassifier("TH", "MJFr14-ASYN");

// Get the list of all images in the current project
//def project = getProject()
//def imagesToExport = project.getImageList()
//// Separate each measurement value in the output file with a tab ("\t")
//def separator = "\t"

saveAnnotationMeasurements('/Volumes/PARK2023-Q5758/Imaging/Imaging @ ANU/Images/Batch 6/MJFr14 asyn_Leica /QuPath Asyn MJFr14 analysis/scripts/Results/ROI.A')
saveDetectionMeasurements('/Volumes/PARK2023-Q5758/Imaging/Imaging @ ANU/Images/Batch 6/MJFr14 asyn_Leica /QuPath Asyn MJFr14 analysis/scripts/Results/ROI.A')
print "Done!"