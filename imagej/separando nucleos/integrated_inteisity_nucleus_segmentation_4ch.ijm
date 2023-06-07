//coletor de intensidade de núcleo stackado optimizado mar2022 por Gabriel Macherini Quaglia

//changelog:
//
//agora ele pega o meio do ok, então vc deixa encima e só da o ok, não precisa mais digitar
//Ele coleta todos os outros backgrounds junto com o da fak, não precisa reposicionar.
//adiciona info da do dia no nome da pasta onde os controles de qualidade e resultados estão


// Só funciona em nucleos segmentados que ainda tem informação pre existente do Roi do nucleo.

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

	title  = getTitle();
	
	roiManager("Add");
	run("Z Project...", "projection=[Sum Slices]");
	roiManager("Select", 0);
	run("Clear Outside");
	run("Split Channels");
	
	selectWindow("C1-SUM_" + title);
	rename(title + "gh2ax");
	selectWindow("C2-SUM_" + title);
	rename(title + "ku80");
	selectWindow("C3-SUM_" + title);
	rename(title + "fak");
	selectWindow("C4-SUM_" + title);
	rename(title + "dapi");
	
	
	// contando o h2ax dentro das áreas do nucleo
	selectWindow(title + "gh2ax");
	run("Measure");
	label_img = getResult("label", 0);
    area = getResult("Area", 0);
	id_gh2ax = getResult("IntDen", 0);
	
	selectWindow(title + "ku80");
	run("Measure");
	id_ku80 = getResult("IntDen", 1);
	
	selectWindow(title + "fak");
	run("Measure");
	id_fak = getResult("IntDen", 2);
	
	selectWindow(title + "dapi");
	run("Measure");
	id_dapi = getResult("IntDen", 3);
 	
	// adiocinar label como novo row
	if (isOpen("r2") == false) { 
		Table.create("r2");	
	}
	
	selectWindow("r2");
	lastrow = Table.size;
	Table.set("label", Table.size, title);
	Table.set("Area", lastrow, area );
	Table.set("id_gh2ax", lastrow, id_gh2ax);
	Table.set("id_ku80", lastrow, id_ku80);
	Table.set("id_fak", lastrow, id_fak);
	Table.set("id_dapi", lastrow, id_dapi);
	
	//fechando o results window
	selectWindow("Results"); 
	run("Close");
	
}
//salvando resultados
selectWindow("r2");
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "resultados.csv");
run("Close All");