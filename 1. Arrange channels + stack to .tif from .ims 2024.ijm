//this macro was redesigned in 2024 by M. Iuliano
//starting with raw image files, this allows for batch opening & processing
//for all z-projection types (MAX MIN AVG MED STD SUM) while also re-ordering channels
//DEFAULT: working with .ims files and pulling from bioformat importer

input = getDirectory("Select folder containing raw images");
output = getDirectory("Select folder to save images in");

//Parameters for the z-stack
//You are able to choose what kind of projection you want, the order/number of the channels in the final image, 
//what type of files you are starting with, and if you want RGB output
stack = newArray("MAX","MIN","AVG","SUM","SD","MED","NONE");
	Dialog.create("Arrange Channels");
		Dialog.addNumber("Number of initial channels",4,0,1,"channel/s");
		Dialog.addNumber("Number of channels in final image",4,0,1,"channel/s");
		Dialog.addString("Starting image type", ".ims");
		Dialog.addString("Final image as a flat RGB? ","no");
		Dialog.addChoice("Z-stack",stack);
	Dialog.show();
	numChan = Dialog.getNumber();
	finChan = Dialog.getNumber();
	suffix= Dialog.getString();
	flat = Dialog.getString();
	ztack = Dialog.getChoice();
	Dialog.create("what colors\nare the channels");
		channels = newArray("Cyan","Green","Red","Blue");
		for(n=0;n<numChan;n++){
			Dialog.addChoice("color",channels,channels[n]);
		}
	Dialog.show();
	chanArray = newArray();
	for(n=0;n<numChan;n++) {
		chanArray = Array.concat(chanArray,Dialog.getChoice());
	}
//setting up and reordering your channels
	Dialog.create("Arrange Channels");
		oldchan = "Current Channels\n";
		for(n=0;n<numChan;n++) {
			oldchan = oldchan+" "+(n+1)+"-"+chanArray[n]+"\n";
		}
		Dialog.addMessage(oldchan);
		finArray = newArray();
		colArray = newArray();
		for(n=0;n<finChan;n++) {
			Dialog.setInsets(20,0,0);
			Dialog.addNumber("Change to channel "+(n+1),(n+1),0,1,"");
			Dialog.setInsets(0,0,0);
			Dialog.addRadioButtonGroup("New channel color",chanArray,1,numChan,chanArray[n]);
		}
	Dialog.show();
	c="";
	for(n=0;n<finChan;n++) {
		finArray = Array.concat(finArray,Dialog.getNumber());
		colArray = Array.concat(colArray,Dialog.getRadioButton());
		c=c+d2s(finArray[n],0);
	}

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
filelist = getFileList(input);
filelist = Array.sort(filelist);

for (i = 0; i < filelist.length; i++) {
	if(File.isDirectory(input + File.separator + filelist[i]))
		processFolder(input + File.separator + filelist[i]);
	if(endsWith(input + File.separator + filelist[i], suffix))
		processFile(input, output, filelist[i]);
 }
}
//function macro
function processFile(input, output, file) {
//bioformats will automatically revert to previous settings, but you can include specific parameters here
		path = input + File.separator +filelist[i];
		run("Bio-Formats Windowless Importer", "open=[path]");
	//brackets needed because if the files have spaces in them, you will get an error
	rename(file);
	title=getTitle();
	selectWindow(title);
	run("Arrange Channels...", "new="+c);
	rename("close_me");
	if(ztack == "AVG") {
		run("Z Project...", "projection=[Average Intensity]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "MAX") {
		run("Z Project...", "projection=[Max Intensity]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "MIN") {
		run("Z Project...", "projection=[Min Intensity]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "SUM") {
		run("Z Project...", "projection=[Sum Slices]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "SD") {
		run("Z Project...", "projection=[Standard Deviation]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "MED") {
		run("Z Project...", "projection=[Median Intensity]");
		selectWindow("close_me");
		close();
	}
	if(ztack == "NONE") {
		selectWindow("close_me");
		rename("stack_close_me");
	}
	projection = ztack+"_close_me";
	selectImage(projection);
	Stack.getDimensions(width, height, nochannels, slices, frames);
	for(s=0;s<nochannels;s++) {
		setSlice(s+1);
		resetMinAndMax();
		run(colArray[s]);
	}
	selectImage(projection);
	rename(title);
	title = getTitle();
	dotIndex = indexOf(title, "." );
	name= substring(title, 0, dotIndex);
	if (flat == "yes") {
		run("Stack to RGB", "slices");
		if(slices==1){
			selectImage(title +" (RGB)");
		}
		else {
			selectImage(title);
		}
		saveAs("Tiff",output+name+" "+ztack);
		close();
		if(slices==1){
			selectImage(title);
			close();
		}
	} else {
		saveAs("Tiff", output + name+" "+ztack);
		close();
	}
}