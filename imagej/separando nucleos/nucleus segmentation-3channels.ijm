
// batch
getDateAndTime(year, month, week, day, hour, min, sec, msec); // pega hora
hoje = "data"+year+"-"+month+1+"-"+day+"--h"+hour+"m"+min // variável com a data
input_path = getDirectory("input files"); //pega onde vai passar o código
filelist = getFileList(input_path); // armazena em uma variavel a lista de arquivos
result_dir = File.isDirectory(input_path + "\\results" + hoje); //pergunta se existe ou não o diretório de resultados
if (result_dir == 0){ //cria o diretorio se ele não existir
	File.makeDirectory(input_path + "\\results-" + hoje); // cria resultado
}
for (f=0; f<filelist.length; f++) { //loop pra cada arquivo da lista de arquivo

	
	//removento resultados e  ROI pré existente
	run("Close All");
	//run("Clear Results"); //não pode mais dar clear results pq o resultados são salvos todos num arquivo so
	anyROIs = roiManager("count");
	
	
	if (anyROIs > 0) {
	    roiManager("Deselect");
	    roiManager("Delete");
	
	}
	// abrir a imagem
	open(input_path + filelist[f]);
	//print(input_path + filelist[f]);
	//pegar dimensões e rodar contraste em todas centrais
	
	getDimensions(width, height, channels, slices, frames);
	
	if (channels == 6) { //comentado antigo se tiver 8 canais, virar 4
		run("Arrange Channels...", "new=135");
		// gammah2ax em magenta
		Stack.setChannel(1);
		run("Magenta");
		run("Enhance Contrast", "saturated=0.35");
		// dna-pk em vermelho
		Stack.setChannel(2);
		run("Red");
		run("Enhance Contrast", "saturated=0.35");
		// fak em verde
//		Stack.setChannel(3);
//		run("Green");
//		run("Enhance Contrast", "saturated=0.35");
		// dapi em ciano
		Stack.setChannel(3);
		run("Blue");
		run("Enhance Contrast", "saturated=0.35");
	}
	// colcar todos os canais no meio e deixa mais bonito pra ver quais z vão ser usados
	Stack.setPosition(1, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(2, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(3, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
//	Stack.setPosition(4, slices/2, 1);
//	run("Enhance Contrast", "saturated=0.35");
	Stack.setDisplayMode("composite");
	w = screenWidth;
	h = screenHeight;
	setLocation(-9, -1, w-9, h+5);
	
	title  = getTitle();
	
	// pegando areas dos nucleos
	run("Duplicate...", "duplicate channels=3");
	rename("dapi_all");
	run("Z Project...", "projection=[Sum Slices]");
	rename("dapi");
	selectWindow("dapi");
	setLocation(-9, -1, w-9, h+5);
	run("Enhance Contrast", "saturated=0.35");
	run("Mean...", "radius=5");
	run("Minimum...", "radius=2");
	run("Threshold...");
	setAutoThreshold("Otsu dark no-reset");
	waitForUser("arrume o threshold");
	run("Convert to Mask");
	run("Fill Holes");
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
	run("Analyze Particles...", "size=90-infinity circularity=0.10-1.00 show=Outlines exclude add");
	selectWindow("dapi");
	close();
	selectWindow("Drawing of dapi");
	close();
	selectWindow("dapi_all");
	close();
	
	selectWindow(title);
	Stack.setActiveChannels("1111");
	nroi_nc = roiManager("count");
	for (i = 0; i < nroi_nc; i++) {
		
		selectWindow(title);
		roiManager("Select", i);
		roiManager("rename", "nucleo_"+i);
		waitForUser("Centro do núcleo", "Aqui vc deve escolher qual é o slice \nque fica no centro do núcleo. \n Coloque nele e de ok. (9)"); 
		
		Stack.getPosition(xa, slicecentral, fa);
		run("Duplicate...", "duplicate slices="+slicecentral-4 +"-"+slicecentral+4);
		rename(title + "_nucleo_" + i + "("+slicecentral+")");
		new_title = getInfo("window.title");
		saveAs("tiff", input_path + "\\results-"+ hoje + "\\" + new_title + ".tif");
		
		// Salvando preview stack Z
		run("Z Project...", "projection=[Sum Slices]");
		Stack.setChannel(1);
		run("Blue");
		run("Enhance Contrast", "saturated=0.35");
		Stack.setChannel(2);
		run("Red");
		run("Enhance Contrast", "saturated=0.35");
//		Stack.setChannel(3);
//		run("Green");
//		run("Enhance Contrast", "saturated=0.35");
		Stack.setActiveChannels("110");
		saveAs("jpeg", input_path + "\\results-"+ hoje + "\\" + new_title + ".jpeg");
		close();
		selectWindow(new_title +".tif");
		close();
		}
}


print(getInfo("window.title"));

	