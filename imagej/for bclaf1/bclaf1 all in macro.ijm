input_path = getDirectory("input files"); //pega onde vai passar o código
filelist = getFileList(input_path); // armazena em uma variavel a lista de arquivos
result_dir = File.isDirectory(input_path + "\\results"); //pergunta se existe ou não o diretório de resultados
if (result_dir == 0){ //cria o diretorio se ele não existir
	File.makeDirectory(input_path + "\\results"); // cria resultado
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
	
	 if (channels == 4) { //comentado antigo se tiver 8 canais, virar 4
		run("Arrange Channels...", "new=234");
	}
	// colcar todos os canais no meio e deixa mais bonito pra ver quais z vão ser usados
	Stack.setPosition(1, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(2, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setPosition(3, slices/2, 1);
	run("Enhance Contrast", "saturated=0.35");
	
	// rodars o duplicate nos stacks de preferencia
	waitForUser("Centro do núcleo", "Aqui vc deve escolher qual é o slice \nque fica no centro do núcleo"); 
	Dialog.create("Seleção de slices");
	Dialog.addMessage("Selecione o slice no Z que mostra o meio do núcleo. Será selecionado 13 slices com este no meio.");
	Dialog.addNumber("experiment number", slices/2);
	//mostrar dialog
	Dialog.show();
	slice_nucleo = Dialog.getNumber();
	// dar duplicate no slices m-6 até m+6
	run("Duplicate...", "duplicate slices="+slice_nucleo-6 +"-"+slice_nucleo+6);
	
	title  = getTitle();
	//cria uma nova imagem em 1 z com canais separados e novo nome para todos
	run("Z Project...", "projection=[Sum Slices]");
	run("Split Channels");
	
	selectWindow("C3-SUM_" + title);
	rename("dapi");
	selectWindow("C1-SUM_" + title);
	rename("("+slice_nucleo+")"+ title + "fak");
	selectWindow("C2-SUM_" + title);
	rename("("+slice_nucleo+")"+ title + "bclaf1");

	//seleciona canal do núcleo e salva Roi do núcleo e salva controle de qualidade do núcleo no results
	selectWindow("dapi");
	run("Enhance Contrast", "saturated=0.35");
	run("Median...", "radius=2");
	run("Gaussian Blur...", "sigma=3");
	run("Minimum...", "radius=1");
	run("Threshold...");
	waitForUser("arrume o threshold");
	run("Convert to Mask");
	run("Fill Holes");
	waitForUser("precisa de Watershed para dividir células grudadas? (process>binary>)");
	run("Analyze Particles...", "size=7000-Infinity pixel show=Outlines exclude add");
	selectWindow("Drawing of dapi");
	saveAs("jpeg", input_path + "\\results\\" + title + "_nd.jpg");
	close("Drawing of dapi");
	

	//renomeia os rois com nomes de nucleo e seta grupo para eles
	nroi_nc = roiManager("count");
	//print("nroi_nc " + nroi_nc);
	for (i = 0; i < nroi_nc; i++) {
		roiManager("Select", i);
		roiManager("rename", "nucleo "+i);
		Roi.setGroup(1)
	}
	// seleciono bclaf1 channel e fazer copia
	selectWindow("("+slice_nucleo+")"+ title + "bclaf1");
	run("Select None");
	run("Duplicate...", "title=bclaf1");

	
	//gero uma planilha com x,y de findmaxima
	run("Find Maxima...", "prominence=180000 output=List");
	selectWindow("Results");
	Table.rename("Results", "findmaxima");
	allpoints = Table.size("findmaxima");
	
	//threshold auto?
	setAutoThreshold("Default dark");
	run("Convert to Mask");
	// loop para fazer dowand no x,y do findmaxima e faz roi
	
	for (k = 0; k < allpoints ; k++) {
		x = Table.get("X", k, "findmaxima");
      	y = Table.get("Y", k, "findmaxima");
		doWand(x, y);
		roiManager("add");
		roiManager("select", k+nroi_nc);
		roiManager("rename", "loci "+k );
		Roi.setGroup(2)
		roiManager("deselect");
	}
	close("findmaxima");
	waitForUser("delete todos os rois que não tem interesse");
	
	// pega os roi loci e transforma em circulos com o dobro do diametro se fosse um circulo
	
	roiManager("Deselect");
	run("Set Measurements...", "area mean centroid integrated display redirect=None decimal=3");
	selectWindow("("+slice_nucleo+")"+ title + "bclaf1");
	roiManager("Deselect");
	roiManager("Measure");
	Table.rename("Results", "loci");

	nroi_nc2 = roiManager("count");
	numberofrows = Table.size("loci");
	for (t = 0; t < numberofrows; t++) {
	 	area = Table.get("Area", t, "loci");
		Ytabela = Table.get("Y", t, "loci");
	 	Xtabela = Table.get("X", t, "loci");
		duplodiametro = (sqrt(area/3.14)*4);
		roiManager("Select", t);
		run("Specify...", "width=" + duplodiametro + " height=" + duplodiametro + " x=" + Xtabela + " y=" + Ytabela +" slice=2 oval constraincircle centered scaled");
		roiManager("Add");
		roiManager("select", t+nroi_nc2);
		roiManager("rename", "loci circulo "+t);
		Roi.setGroup(3)
	}
	close("loci");
	//salva os rois
	roiManager("save", input_path + "\\results\\" + title + "roi.zip");

	//volta para imagem antes do zproject, seleciona as áreas dos rois e salva nos results
	selectWindow(title);
	getDimensions(xxx, xxx, xxxx, allslices, xxxx);
	

	RoiManager.selectGroup(1);
	roiManager("delete");
	RoiManager.selectGroup(2);
	roiManager("delete");

	roicount = roiManager("count");
	for (n = 0; n < roicount; n++) {
		roiManager("select", n);
		run("Duplicate...", " duplicate slices=0-"+allslices+" duplicate channels=1-3 title=roi_"+ n);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside", "stack");
		saveAs("tif", input_path + "\\results\\" + title + "roi_"+ n +".tif");
		selectWindow(title);
	}
}

	