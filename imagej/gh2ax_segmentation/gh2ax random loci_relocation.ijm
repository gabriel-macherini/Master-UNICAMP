
// -------------------------------------------------------------------------------------------------
//					Esse macro é para passar na imagem original com os rois de gh2ax abertos no roi manager

// 					Ele serve para realocar os rois de gh2ax foci dos nucleos em áreas que não tem gh2ax para fazer um comparativo
//  				de Correlação de Pearson de áreas com gh2ax foci, com áreas que não tem gh2ax foci dentro do núcleo

//					Ele cria imagens no final do mesmo tamanho e quantidade de gh2ax foci por imagem
// -------------------------------------------------------------------------------------------------




onde_esta = getInfo("image.directory");
w = screenWidth
h = screenHeight


getDimensions(width, height, channels, slices, frames);

// colcar todos os canais no meio e deixa mais bonito pra ver quais z vão ser usados
Stack.setPosition(1, slices/2, 1);
run("Enhance Contrast", "saturated=0.35");
Stack.setPosition(2, slices/2, 1);
run("Enhance Contrast", "saturated=0.35");
Stack.setPosition(3, slices/2, 1);
run("Enhance Contrast", "saturated=0.35");
Stack.setPosition(4, slices/2, 1);
run("Enhance Contrast", "saturated=0.35");
Stack.setDisplayMode("composite");
setLocation(-9, -1, w-9, h+5);

title  = getTitle();
//cria uma nova imagem em 1 z com canais separados e novo nome para todos
run("Z Project...", "projection=[Sum Slices]");
run("Split Channels");

selectWindow("C1-SUM_" + title);
rename("gammah2ax");

selectWindow("C2-SUM_" + title);
rename("ku80");
close();
selectWindow("C3-SUM_" + title);
rename("fak");
close();
selectWindow("C4-SUM_" + title);
rename("dapi");
close();

selectWindow("gammah2ax");
setLocation(-9, -1, w-9, h+5);
RoiManager.selectGroup(1);
roiManager("delete");
waitForUser("Mude os locis para \nonde não tem gammah2ax");

roicount = roiManager("count");
selectWindow(title);
getDimensions(xxx, xxx, xxxx, allslices, xxxx);

result_dir = File.isDirectory(onde_esta + "\\results_random"); //pergunta se existe ou não o diretório de resultados
if (result_dir == 0){ //cria o diretorio se ele não existir
	File.makeDirectory(onde_esta + "\\results_random"); // cria resultado
}

	
	for (n = 0; n < roicount; n++) {
		roiManager("select", n);
		run("Duplicate...", " duplicate slices=0-"+allslices+" duplicate channels=1-4 title=roi_"+ n);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside", "stack");
		saveAs("tif", onde_esta + "\\results_random\\" + title + "_random_roi_"+ n +".tif");
		selectWindow(title);
					
		} 
roiManager("save", onde_esta + "\\results_random\\" + title + "_random_roi.zip");

run("Close All");
roiManager("deselect");
roiManager("delete");
	
	
	