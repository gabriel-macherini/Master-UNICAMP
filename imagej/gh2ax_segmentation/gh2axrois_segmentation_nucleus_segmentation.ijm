
// -------------------------------------------------------------------------------------------------
//					Esse macro é para passar na imagem dos nucleos segmentados que tem informação do roi do nucleo.

// 					Ele serve para segmentar os gh2ax foci dos nucleos baseado no Threshold que você escolher

//					Ele cria imagens no final de todos os rois por imagem
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
	//print(input_path + filelist[f]);
	//pegar dimensões e rodar contraste em todas centrais
	
	getDimensions(width, height, channels, slices, frames);
	title  = getTitle();

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
	
	// selecionando o roi que vem com a imagem, adicionando e removendo o lado de fora
	roiManager("Add");
	roiManager("Select", 0);
	setForegroundColor(255, 255, 255);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	
	// criando o zproject do gh2ax
	run("Duplicate...", "duplicate channels=1");
	rename("gh2ax");
	run("Z Project...", "projection=[Sum Slices]");
	rename(title + "_gh2ax");
	setLocation(-9, -1, w-9, h+5);
	run("Enhance Contrast", "saturated=0.35");
	selectWindow(title + "_gh2ax");
			
			
			
	// setando os rois dos nucleos para roi group 7		
	nroi_nc = roiManager("count");
	print("imagem: " + title + "- numeros de nucleos: " +nroi_nc);
	nroi_nc = roiManager("count");
	for (j = 0; j < nroi_nc; j++) {
		roiManager("Select", j);
		Roi.setGroup(8);
	}

	// Selecionando o threshold do gh2ax para selecionar os rois de loci de gh2ax

	selectWindow(title + "_gh2ax");
	setAutoThreshold("Otsu dark reset");
	getThreshold(lower, upper);	
	setThreshold(125000, upper); // escolhi esse número pois se eu achei bom 15k para diferenciar gh2ax loci de controle, isso x9 slices seria perto de 135k
	waitForUser("arrume o threshold");
	run("Convert to Mask");	
	
	
	// Loop para pegar as áreas de cada roi de cada nucleo separadamente e salvar dentro da pasta de resultados.
	
	nroi_nc = roiManager("count");		
	for (i = 0; i < nroi_nc; i++) {
		selectWindow(title + "_gh2ax");
		roiManager("Select", i);
		roiManager("rename", "nucleo_"+i);
		run("Analyze Particles...", "size=0.15-1.60 circularity=0.10-1.00 show=Outlines exclude summarize add"); // menor area de loci de gh2ax vi que é 0.15~ e não quero nada maior que 1.6 µm, muito grande.
		RoiManager.selectGroup(0);
		if (RoiManager.selected != 0) { // pulo do gato, se não tem roi selecinado, não roda essse loop
			nroi_novo = roiManager("count");
			for (t = nroi_nc; t < nroi_novo; t++) {
				selectWindow(title);
	   			roiManager("select", t);
	   			Roi.setGroup(1);
	   			roiManager("Rename", "roi_"+t-nroi_nc);
	   			esseroi = Roi.getName;
	   			run("Enlarge...", "enlarge=.5"); //setei um enlarge de 0.5µm para todos os rois já que é uma margem em volta e não acho necessário criar uma equação pra pegar ao proporcional agora.
	   			run("Duplicate...", "duplicate");
	   			saveAs("tiff", input_path + "\\results-"+ hoje + "\\" + title + "nucleo_" + i +"-"+ esseroi + ".tiff");
	   			close();
			}
		}
		RoiManager.selectGroup(1);
		if (RoiManager.selected != 0) { //se não tem roi, não deleta roi, sem isso ele deletaria os rois dos outros núcleos. 
			roiManager("save", input_path + "\\results-"+ hoje + "\\" + title + "nucleo_" + i +"_rois" + ".zip");
			roiManager("delete");
		}	
	}

}
//salvando resultados
selectWindow("Summary");
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "Summary.csv");

	
	
	