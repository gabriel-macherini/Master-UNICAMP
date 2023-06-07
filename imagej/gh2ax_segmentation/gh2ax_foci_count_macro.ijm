
// -------------------------------------------------------------------------------------------------
//					Esse macro é para passar na imagem original

// 					Ele serve para contar os gh2ax foci das células baseado no Threshold que você escolher

//					Ele cria um arquivo no final com todas informações por imagem
// -------------------------------------------------------------------------------------------------




// batch
getDateAndTime(year, month, week, day, hour, min, sec, msec); // pega hora
hoje = "data"+year+"-"+month+1+"-"+day+"--"+hour+"e"+min // variável com a data
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
	print(input_path + filelist[f]);
	//pegar dimensões e rodar contraste em todas centrais
	
	getDimensions(width, height, channels, slices, frames);
	
	if (channels == 8) { //comentado antigo se tiver 8 canais, virar 4
		run("Arrange Channels...", "new=1357");
		// gammah2ax em magenta
		Stack.setChannel(1);
		run("Magenta");
		run("Enhance Contrast", "saturated=0.35");
		// dna-pk em vermelho
		Stack.setChannel(2);
		run("Red");
		run("Enhance Contrast", "saturated=0.35");
		// fak em verde
		Stack.setChannel(3);
		run("Green");
		run("Enhance Contrast", "saturated=0.35");
		// dapi em ciano
		Stack.setChannel(4);
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
	Stack.setPosition(4, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setDisplayMode("composite");
	w = screenWidth;
	h = screenHeight;
	setLocation(-9, -1, w-9, h+5);
	
	// rodars o duplicate nos stacks de preferencia
	waitForUser("Centro do núcleo", "Aqui vc deve escolher qual é o slice \nque fica no centro do núcleo \n coloque nele e de ok. (9)"); 
	
	Stack.getPosition(xa, slicecentral, fa)
	run("Duplicate...", "duplicate slices="+slicecentral-4 +"-"+slicecentral+4);
	//Dialog.create("Seleção de slices");
	//Dialog.addMessage("Selecione o slice no Z que mostra o meio do núcleo. Será selecionado 13 slices com este no meio.");
	//Dialog.addNumber("experiment number", slices/2);
	//mostrar dialog
	//Dialog.show();
	//slicecentral = Dialog.getNumber();
	// dar duplicate no slices m-6 até m+6
	//run("Duplicate...", "duplicate slices="+slicecentral-4 +"-"+slicecentral+4);
	
	title  = getTitle();
	
	run("Z Project...", "projection=[Sum Slices]");
	run("Split Channels");
	
	selectWindow("C1-SUM_" + title);
	rename("("+slicecentral+")"+ title + "Gama H2AX");
	selectWindow("C2-SUM_" + title);
	rename("("+slicecentral+")"+ title + "ku80");
	selectWindow("C3-SUM_" + title);
	rename("("+slicecentral+")"+ title + "fak");
	selectWindow("C4-SUM_" + title);
	rename("dapi");
	
	selectWindow("dapi");
	run("Enhance Contrast", "saturated=0.35");
	run("Mean...", "radius=5");
	run("Minimum...", "radius=2");
	run("Threshold...");
	setAutoThreshold("Otsu dark no-reset");
	waitForUser("arrume o threshold");
	run("Convert to Mask");
	run("Fill Holes");
	//waitForUser("precisa de Watershed para dividir células grudadas? (process>binary>)");
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
	run("Analyze Particles...", "size=150-Infinity circularity=0.10-1.00 show=Outlines exclude add");
	selectWindow("Drawing of dapi");
	//saveAs("jpeg", input_path + "\\results-"+hoje+"\\" + title + "_nd.jpg");
	selectWindow("("+slicecentral+")"+ title + "Gama H2AX");
	run("Enhance Contrast", "saturated=0.35");
			
	nroi_nc = roiManager("count");
	
	for (i = 0; i < nroi_nc; i++) {
		selectWindow("("+slicecentral+")"+ title + "Gama H2AX");
		run("Enhance Contrast", "saturated=0.35");
		roiManager("Select", i);
		roiManager("rename", "nucleo_"+i);
		run("Duplicate...", "duplicate channels=1");
		rename(title+"nucleo_"+i);
		run("Clear Outside");
		setAutoThreshold("Otsu dark no-reset");
		waitForUser("arrume o threshold");
		run("Convert to Mask");
		run("Analyze Particles...", "size=0.15-5.00 circularity=0.05-1.00 show=Outlines display exclude summarize add");
		saveAs("results", input_path + "\\results-"+ hoje + "\\" + "("+slicecentral+")"+ title + "nucleo_" + i + "_results.csv");
		run("Clear Results");
	}

	
	//salvando resultados
	roiManager("Deselect");
	roiManager("save", input_path + "\\results-"+hoje+ "\\" + "(" +slicecentral + ")" + title + "_gammah2ax_roi.zip");
}
//salvando resultados
selectWindow("Summary");
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "Summary.csv");

	
	
	