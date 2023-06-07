nome_image = getTitle();
onde_esta = getInfo("image.directory");

selectWindow(nome_image);
run("Duplicate...", "title=allch.tif duplicate");
Stack.setDisplayMode("composite");
Stack.setDisplayMode("composite");
Stack.setActiveChannels("11");

//adicione localização do ponta esquerda da escala no roi manager
if ((roiManager("count") > 0)) {
	roiManager("Select", 0);
	run("Scale Bar...", "width=1 height=4 thickness=4 font=14 color=White background=None location=[At Selection] horizontal bold overlay");
}
run("Scale Bar...", "width=1 height=4 thickness=4 font=14 color=White background=None location=[Lower Right] horizontal bold overlay");
run("Select None");
run("RGB Color", "slices keep");
run("Animation Options...", "speed=8");
saveAs("gif", onde_esta+ "\\" + "zoom_allchannels.gif");
close("allch.tif");

selectWindow(nome_image);
run("Duplicate...", "title=channels.tif duplicate");
run("Split Channels");

selectWindow("C1-channels.tif");
run("RGB Color", "slices keep");
run("Animation Options...", "speed=8");
saveAs("gif", onde_esta+ "\\" + "zoom_channel 1.gif");
close("C1-channels.tif");

selectWindow("C2-channels.tif");
run("RGB Color", "slices keep");
run("Animation Options...", "speed=8");
saveAs("gif", onde_esta+ "\\" + "zoom_channel 2.gif");
close("C2-channels.tif");

close("*");

