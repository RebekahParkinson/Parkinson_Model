# Mouse Activity Analyzer - MATLAB Implementation

## Overview

This repository contains MATLAB code for analyzing mouse locomotor activity from open field videos containing a circular arena (38.5 cm diameter). The code calculates parameters such as distance traveled, velocity, acceleration, resting time, and thigmotaxis. The original code, Mouse Activity Analyzer, was developed by **Renzhi Han** at **The Ohio State University** and is freely available as an open-source project.

**Reference:**
- Zhang C, Li H, Han R. An open-source video tracking system for mouse locomotor activity analysis. BMC Res Notes. 2020 Jan 30;13(1):48. doi: 10.1186/s13104-020-4916-6. PMID: 32000855; PMCID: PMC6990588.
- [Mouse Activity Analyzer on GitHub](https://github.com/HanLab-OSU/MouseActivity)

## Requirements

- Tested on MATLAB R2018b and MATLAB R2019a
- Download the `poi` library from the GitHub repository linked above

## Setup

1. Download the following files and folders from this repository:
   - `MouseActivity5.m`
   - `xlwrite.m`
   - `poi_library` folder

2. Ensure that the `poi_library` folder is in the same directory as the MATLAB source files.

## Running the Analyzer

To run the Mouse Activity Analyzer:

1. Open MATLAB R2018b or MATLAB R2019a.
2. Navigate to the folder containing `MouseActivity5.m`.
3. Double-click on `MouseActivity5.m` to open it in MATLAB.
4. Click the "Run" button and follow the onscreen instructions to analyze your video files.

### Note:
- Supported video formats: `.mp4` and `.mov`
- Other formats may not work properly.

## Batch Processing

For analyzing multiple videos in a folder:

1. Download the following additional files:
   - `OpenField.m`
   - `OpenField_Automator.m`

2. Place these files in the same directory as the other MATLAB source files.

3. Run `OpenField_Automator.m` to process all videos in the specified folder.

## Parameters

The following parameters have been predefined:

- `threshold = 0.8`
- `time = 1 min (1800 frames)`
- `number of mice = 1`
- `min pixel = 25`

These parameters can be adjusted as needed for your specific experiments.

## Contact

For any questions or issues, please contact the original author Renzhi Han or refer to the [original GitHub repository](https://github.com/HanLab-OSU/MouseActivity).

---

This README provides a comprehensive guide for setting up and running the Mouse Activity Analyzer in MATLAB. Follow the instructions carefully to ensure smooth operation and accurate analysis of your mouse locomotor activity videos.
