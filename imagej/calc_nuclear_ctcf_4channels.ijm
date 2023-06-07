//coletor de intensidade de núcleo stackado optimizado mar2022 por Gabriel Macherini Quaglia

//changelog:
//agora ele pega o meio do ok, então vc deixa encima e só da o ok, não precisa mais digitar
//Ele coleta todos os outros backgrounds junto com o da fak, não precisa reposicionar.
//adiciona info da do dia no nome da pasta onde os controles de qualidade e resultados estão


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

	title  = getTitle();
	
	run("Z Project...", "projection=[Sum Slices]");
	run("Split Channels");
	
	selectWindow("C1-SUM_" + title);
	rename("("+slicecentral+")"+ title + "Gama H2AX");
	selectWindow("C2-SUM_" + title);
	rename("("+slicecentral+")"+ title + "dna-pk");
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
	run("Analyze Particles...", "size=150-infinity circularity=0.10-1.00 show=Outlines exclude add");
	selectWindow("Drawing of dapi");
	saveAs("jpeg", input_path + "\\results-"+hoje+"\\" + title + "_nd.jpg");
	
	// contando o h2ax dentro das áreas do nucleo
	selectWindow("("+slicecentral+")"+ title + "fak");
	run("Enhance Contrast", "saturated=0.35");
	
	// inicio do loop 1
	nroi_nc = roiManager("count");
	//print("nroi_nc " + nroi_nc);
	for (i = 0; i < nroi_nc; i++) {
		roiManager("Select", i);
		roiManager("rename", "nucleo"+i);
		run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
		run("Measure");
		
	}
	// inicio do loop 2
	selectWindow("("+slicecentral+")"+ title + "dna-pk");
	run("Enhance Contrast", "saturated=0.35");
	for (t = 0; t < nroi_nc; t++) {
		roiManager("Select", t);
		run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
		run("Measure");
	}
	selectWindow("("+slicecentral+")"+ title + "Gama H2AX");
	run("Enhance Contrast", "saturated=0.35");
	for (t = 0; t < nroi_nc; t++) {
		roiManager("Select", t);
		run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
		run("Measure");
		
	}
	//run("Set Measurements...", "area mean integrated display redirect=[(12.5)ct-h2ax-647-dna-pk-546-fak-488-dapi-01_Out_Channel Alignment-1.cziGama H2AX] decimal=3");
	
	// fazer seleção do background para descontar no calculo da fluorecência
	selectWindow("("+slicecentral+")"+ title + "fak");
	run("Enhance Contrast", "saturated=0.35");
	setTool("oval");
	makeOval(0, 0, 200, 200);
	waitForUser("Parte manual", "Pegar primeira area de background");
	roiManager("Add");
	//print("nroi_nc " + nroi_nc);
	roiManager("select", (nroi_nc));
	roiManager("rename", "bc_fak_1");
	run("Measure");
	
	
	makeOval(0, 0, 200, 200);
	waitForUser("Parte manual", "Pegar segunda area de background");
	roiManager("Add");
	roiManager("select", nroi_nc+1);
	roiManager("rename", "bc_fak_2");
	run("Measure");
	
	
	makeOval(0, 0, 200, 200);
	waitForUser("Parte manual", "Pegar terceira area de background");
	roiManager("Add");
	roiManager("select", nroi_nc+2);
	roiManager("rename", "bc_fak_3");
	run("Measure");

	//usar o mesma area do bc pra fazer para os 3 canais.


	selectWindow("("+slicecentral+")"+ title + "dna-pk");
	roiManager("select", (nroi_nc));
	roiManager("rename", "bc_dna-pk_1");
	run("Measure");
	roiManager("select", (nroi_nc+1));
	roiManager("rename", "bc_dna-pk_2");
	run("Measure");
	roiManager("select", (nroi_nc+2));
	roiManager("rename", "bc_dna-pk_3");
	run("Measure");

	selectWindow("("+slicecentral+")"+ title + "Gama H2AX");
	roiManager("select", (nroi_nc));
	roiManager("rename", "bc_Gama H2AX_1");
	run("Measure");
	roiManager("select", (nroi_nc+1));
	roiManager("rename", "bc_Gama H2AX_2");
	run("Measure");
	roiManager("select", (nroi_nc+2));
	roiManager("rename", "bc_Gama H2AX_3");
	run("Measure");
	
	//salvando resultados
	saveAs("results", input_path + "\\results-"+hoje+ "\\" + "results.csv");
	
}
//salvando resultados
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "results.csv");