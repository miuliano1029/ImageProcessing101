//@ File (label = "Input directory", style = "directory") input
//@ File (label = "Output directory", style = "directory") output
//@ String (label = "File suffix", value = ".tif") suffix

//thjis macro has been modified by M. Iuliano 2024 from exisiting macros and resources available from ImageJ
//this macro takes an image (up to 3 channels) and will split the channels into separate folders
//it will also take raw measurements of each channel and save as a .csv

input += File.separator;
output += File.separator;

Dialog.create("Channel Info");
	Dialog.addNumber("How many channels?",4,0,1,"channel/s");
Dialog.show();
numChan = Dialog.getNumber();
channels = newArray("C1","C2","C3","C4");

for(n=0;n<numChan;n++){
			Dialog.addChoice("color",channels,channels[n]);
		}
chan = newArray();
for(n=0;n<numChan;n++) {
		chan = Array.concat(chan,Dialog.getChoice());
	}
text=newArray();

//loop to identify each channel (will end up as the folder housing each channel
for(n=0;n<numChan;n++){
	Dialog.create("Channels");
		Dialog.addString(chan[n], chan[n]);
	Dialog.show();
	text= Array.concat(text, Dialog.getString());
	}

textArray= Array.reverse(text);
chanArray= Array.reverse(chan);

for(n=0;n<numChan;n++){	
	if(File.exists(input+channels[n])!=1) {
		File.makeDirectory(output + chan[n]+ " " +text[n]);
	}

}

run("Clear Results");
run("Set Measurements...", "area min max integrated display redirect=None decimal=5");

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix (defaul is .tif...if need to change, see top lines of this macro
function processFolder(input) {
list = getFileList(input);
list = Array.sort(list);
//waitForUser("");

for (i = 0; i < list.length; i++) {
	if(File.isDirectory(input + File.separator + list[i]))
		processFolder(input + File.separator + list[i]);
	if(endsWith(list[i], suffix))
		processFile(input, output, list[i]);
 }
}

function processFile(input, output, file) {
open(input + file);
roiManager("reset")
run("Select All");
roiManager("Add");
title = getTitle();
roiManager("select", 0);
roiManager("multi-measure measure_all append");
roiManager("reset")
run("Split Channels");
	c=0;
	for(l=0;l<numChan;l++) {	
		title = getTitle();
		selectWindow(title);
		saveAs("Tiff", output + chanArray[l]+" "+textArray[l]+ File.separator + title);
		close();
		c=c+1;
	}
}
selectWindow("Results");
saveAs("Results", output +"Channel Measurements.csv");
