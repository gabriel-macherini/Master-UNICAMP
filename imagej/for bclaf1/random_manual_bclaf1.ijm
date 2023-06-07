// Fazendo o ROI random na mão.
// Você deve saber qual foi o slide do meio que foi usado se quiser usar o mesmo.
// é necessário ter salvo os ROI das areas de Loci para mover manualmente eles

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

waitForUser("Abra os Roi da área feita no outro macro de BCLAF1, delete os Roi de loci, \nreposicione os ROI de loci para areas random, remova os ROI dos núcleos");


input_path = getDirectory("image");
result_dir = File.isDirectory(input_path + "\\results_random"); //pergunta se existe ou não o diretório de resultados
if (result_dir == 0){ //cria o diretorio se ele não existir
	File.makeDirectory(input_path + "\\results_random"); // cria resultado
}


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


getDimensions(xxx, xxx, xxxx, allslices, xxxx);
title  = getTitle();
roicount = roiManager("count");
	for (n = 0; n < roicount; n++) {
		roiManager("select", n);
		run("Duplicate...", " duplicate slices=0-"+allslices+" duplicate channels=1-3 title=roi_"+ n);
		setBackgroundColor(0, 0, 0);
		run("Clear Outside", "stack");
		saveAs("tif", input_path + "\\results_random\\" + title + "roi_random"+ n +".tif");
		selectWindow(title);
	}
roiManager("save", input_path + "\\results_random\\" + title + "roi.zip");


//  Fecha tudo
run("Close All");
roiManager("deselect");
roiManager("delete");