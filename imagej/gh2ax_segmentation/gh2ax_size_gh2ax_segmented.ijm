// -------------------------------------------------------------------------------------------------
//					Esse macro é para passar na imagem original

// 					Ele serve para contar os gh2ax foci das células baseado no Threshold que você escolher

//					Ele cria um arquivo no final com todas informações por imagem
// -------------------------------------------------------------------------------------------------



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
	

	roiManager("Deselect");
	run("Z Project...", "projection=[Sum Slices]");
	run("Duplicate...", "duplicate channels=1");
	getDimensions(width, height, channels, slices, frames);
	title = getTitle();
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Set Measurements...", "area mean shape integrated kurtosis display redirect=None decimal=3");
	run("Analyze Particles...", "size=0.01-Infinity add");
	selectWindow(title);
	run("Measure");
}
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "gh2ax size resultados.csv");
run("Close All");
