// batch
getDateAndTime(year, month, week, day, hour, min, sec, msec); // pega hora
hoje = year+"-"+month+1+"-"+day+"--"+hour+"-"+min // variável com a data
input_path = getDirectory("input files"); //pega onde vai passar o código
filelist = getFileList(input_path); // armazena em uma variavel a lista de arquivos
result_dir = File.isDirectory(input_path + "\\fakcount-" + hoje); //pergunta se existe ou não o diretório de resultados
if (result_dir == 0){ //cria o diretorio se ele não existir
	File.makeDirectory(input_path + "\\fakcount-" + hoje); // cria resultado
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
		run("Arrange Channels...", "new=1358");
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
	
	// rodars o duplicate nos stacks de preferencia
	waitForUser("Centro do núcleo", "Aqui vc deve escolher qual é o slice \nque fica no centro do núcleo"); 
	Dialog.create("Seleção de slices");
	Dialog.addMessage("Selecione o slice no Z que mostra o meio do núcleo. Será selecionado 13 slices com este no meio.");
	Dialog.addNumber("experiment number", slices/2);
	//mostrar dialog
	Dialog.show();
	slice_nucleo = Dialog.getNumber();
	// dar duplicate no slices m-6 até m+6
	run("Duplicate...", "duplicate slices="+slice_nucleo-4 +"-"+slice_nucleo+4);
	
	title  = getTitle();
	
	run("Z Project...", "projection=[Sum Slices]");
	run("Split Channels");
	
	selectWindow("C1-SUM_" + title);
	rename("("+slice_nucleo+")"+ title + "Gama H2AX");
	selectWindow("C2-SUM_" + title);
	rename("("+slice_nucleo+")"+ title + "ku80");
	selectWindow("C3-SUM_" + title);
	rename("("+slice_nucleo+")"+ title + "fak");
	selectWindow("C4-SUM_" + title);
	rename("dapi");
	
	selectWindow("dapi");
	run("Enhance Contrast", "saturated=0.35");
	run("Mean...", "radius=5");
	run("Minimum...", "radius=2");
	run("Threshold...");
	waitForUser("arrume o threshold");
	run("Convert to Mask");
	run("Fill Holes");
	waitForUser("precisa de Watershed para dividir células grudadas? (process>binary>)");
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
	run("Analyze Particles...", "size=7000-Infinity pixel show=Outlines exclude add");
	selectWindow("Drawing of dapi");
	saveAs("jpeg", input_path + "\\fakcount-"+hoje+"\\" + title + "_nd.jpg");
	
	// selecionando canal da fak
	selectWindow("("+slice_nucleo+")"+ title + "fak");
	run("Enhance Contrast", "saturated=0.35");
	run("Threshold...");
	waitForUser("arrume o threshold");
	//selecionar núcleo
	// inicio do loop 1
	nroi_nc = roiManager("count");
	for (i = 0; i < nroi_nc; i++) {
		roiManager("Select", i);
		roiManager("rename", "nucleo"+i);
		run("Analyze Particles...", "size=0.15-Infinity exclude summarize");
	}
}	
//salvar sumario
selectWindow("Summary");
saveAs("results", input_path + "\\fakcount-"+hoje+ "\\" + "fak_cluster_count.csv");