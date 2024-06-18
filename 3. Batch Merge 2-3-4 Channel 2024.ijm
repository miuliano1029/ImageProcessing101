Dialog.create("Merge Function");
		Dialog.addNumber("how many channels in final image",4,0,1,"channel/s");
		Dialog.addString("Image Suffix","Merge");
Dialog.show;
choice = Dialog.getNumber();
suffix = Dialog.getString();
if (choice == "2") {
	twochan();
}
if (choice == "3") {
	threechan();
}
if (choice == "4") {
	fourchan();
}

function twochan() {
    setBatchMode(true);
    file1 = getDirectory("Red");
    list1 = getFileList(file1);
    n1 = lengthOf(list1);
    file2 = getDirectory("Green");
    list2 = getFileList(file2); 
    file4 = getDirectory ("Merged");
    list4 = getFileList(file4);
    n3 = lengthOf(list4);
    small = n1;
    //condition for for-loop
    for(i = n3 ++; i < small; i++) {
      name = list1[i]+ " "+suffix;
      open(file1 + list1[i]);
      open(file2 + list2[i]);
      run("Merge Channels...", "c1=[" + list1[i] + "] c2=[" + list2[i] + "] create ignore");
      saveAs("tiff", file4+name);
    }
    
function threechan() {
    setBatchMode(true);
    file1 = getDirectory("Red");
    list1 = getFileList(file1);
    n1 = lengthOf(list1);
    file2 = getDirectory("Green");
    list2 = getFileList(file2); 
    file3 = getDirectory("Blue");
    list3 = getFileList(file3);
    file4 = getDirectory ("Merged");
    list4 = getFileList(file4);
    n3 = lengthOf(list4);
    small = n1;
    //condition for for-loop
    for(i = n3 ++; i < small; i++) {
      name = list1[i]+ " "+suffix;
      open(file1 + list1[i]);
      open(file2 + list2[i]);
      open(file3 + list3[i]);
      run("Merge Channels...", "c1=[" + list1[i] + "] c2=[" + list2[i] + "] c3=[" + list3[i] + "] create ignore");
      saveAs("tiff", file4 + name);
    }
    
function fourchan() {
    setBatchMode(true);
    file1 = getDirectory("Red");
    list1 = getFileList(file1);
    n1 = lengthOf(list1);
    file2 = getDirectory("Green");
    list2 = getFileList(file2); 
    file3 = getDirectory("Blue");
    list3 = getFileList(file3);
    file4 = getDirectory("Cyan");
    list4 = getFileList(file4);
    file5 = getDirectory ("Merged");
    list5 = getFileList(file5);
    n4 = lengthOf(list5);
    small = n1;
    //condition for for-loop
    for(i = n4 ++; i < small; i++) {
      name = list1[i]+ " "+suffix;
      open(file1 + list1[i]);
      open(file2 + list2[i]);
      open(file3 + list3[i]);
      open(file4 + list4[i]);
      run("Merge Channels...", "c1=[" + list1[i] + "] c2=[" + list2[i] + "] c3=[" + list3[i] + "] c4=[" + list4[i] + "] create ignore");
      saveAs("tiff", file5 + name);
    }