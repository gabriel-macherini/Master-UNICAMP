
function processChannels() {
// pt : Essa função da o auto contraste e coloca no meio dos cortes
    getDimensions(width, height, channels, slices, frames);
    
    for (i = 0; i < channels; i++) {
        Stack.setPosition(i, slices/2, 1);
        run("Enhance Contrast", "saturated=0.35");
    }
}

nome_image = getTitle();
onde_esta = getInfo("image.directory");

//3ch
processChannels();
selectWindow(nome_image);
run("Duplicate...", "title=3ch.tif duplicate");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("1110");
//run("Scale Bar...", "width=5 height=20 font=86 color=White background=None location=[Lower Right] bold overlay");
run("Scale Bar...", "width=5 height=5 thickness=4 font=24 color=White background=None location=[Lower Right] horizontal bold overlay");
saveAs("Jpeg", onde_esta+ "\\" + "3ch.tif");
close("3ch.tif");
//channels separados
selectWindow(nome_image);
run("Duplicate...", "title=sep duplicate");
run("Split Channels");

selectWindow("C1-sep");
saveAs("Jpeg", onde_esta+ "\\" + "channel 1.tif");
close("C1-sep");

selectWindow("C2-sep");
saveAs("Jpeg", onde_esta+ "\\" + "channel 2.tif");
close("C2-sep");

selectWindow("C3-sep");
saveAs("Jpeg", onde_esta+ "\\" + "channel 3.tif");
close("C3-sep");

if (isOpen("C4-sep")== 1)  {
	selectWindow("C4-sep"); //ver se tem
	saveAs("Jpeg", onde_esta+ "\\" + "4ch.tif");
	close("C4-sep");
}


open(onde_esta + "//" + "channel 1.jpg");
open(onde_esta + "//" + "channel 2.jpg");
open(onde_esta + "//" + "channel 3.jpg");
open(onde_esta + "//" + "3ch.jpg");

run("Images to Stack", "name=2x2 title=[]");
saveAs("tiff", onde_esta+ "\\" + "2x2 stack.tif");
run("Animation Options...", "speed=2");
saveAs("gif", onde_esta+ "\\" + "2x2 gif.tif");

run("Make Montage...", "columns=2 rows=2 scale=1 border=5");
saveAs("Jpeg", onde_esta+ "\\" + "2x2.tif");
close("2x2 stack.tif");
close("Montage");
