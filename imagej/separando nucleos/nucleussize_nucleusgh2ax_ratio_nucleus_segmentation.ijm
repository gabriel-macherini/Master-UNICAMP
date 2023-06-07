// Gabriel Macherini Quaglia  dez2022

// -- Segmenta gh2ax loci no threshold auto ( estilo Otsu), pega Area em µm² de todos os gh2ax foci combinados, do nucleo (do roi pré existente da imagem), --
// -- e a intensidade do sinal do canal de gh2ax de ambos e tira a porcentagem que os foci representam do núcleo.

// NOTA: esse macro não funciona se não tiver o roi do núcleo inserido na imagem .tif, se for necessário, descomentar (remover //)  e arrumar o segmentador --



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
	//run("Close All");

	//run("Clear Results"); //não pode mais dar clear results pq o resultados são salvos todos num arquivo so
	anyROIs = roiManager("count");	
	if (anyROIs > 0) {
	    roiManager("Deselect");
	    roiManager("Delete");
	}
	// abrir a imagem
	open(input_path + filelist[f]);
	print(input_path + filelist[f]);
	

	// pega titulo original
	ori_title = getTitle();

	// segmetador do nucleo caso a imagem não tiver roi do nucleo no .tif
//	run("Duplicate...", "duplicate channels=4"); // supondo que o canal do dapi é o 4, mude se for outro
//	rename("dapi_all");
//	run("Z Project...", "projection=[Sum Slices]");
//	rename("dapi");
//	selectWindow("dapi");
//	setLocation(-9, -1, w-9, h+5);
//	run("Enhance Contrast", "saturated=0.35");
//	run("Mean...", "radius=5");
//	run("Minimum...", "radius=2");
//	run("Threshold...");
//	setAutoThreshold("Otsu dark no-reset");
//	waitForUser("arrume o threshold");
//	run("Convert to Mask");
//	run("Fill Holes");
//	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
//	run("Analyze Particles...", "size=90-infinity circularity=0.10-1.00 show=Outlines exclude add");
//	selectWindow("dapi");
//	close();
//	selectWindow("Drawing of dapi");
//	close();
//	selectWindow("dapi_all");
//	close();
			
	// adiciona roi do nucleo e remove outside
	roiManager("Add");
	roiManager("Select", 0);
	run("Clear Outside");
	roiManager("Deselect");
	
		
	// duplica canal de gh2ax [1] e faz z project
	run("Duplicate...", "duplicate channels=1");
	run("Z Project...", "projection=[Sum Slices]");
	run("Enhance Contrast", "saturated=0.35");
	
	// pega o nome da janela do z project
	title = getTitle();
	
	// duplica, faz threshold auto, faz mas cara, pega gh2ax foci > 0.15µm²
	run("Duplicate...", " ");
	setAutoThreshold("Otsu dark");
	run("Convert to Mask");
	run("Analyze Particles...", "size=0.15-Infinity add");
	
	// na gh2ax zproject seleciona todos os rois de gh2ax e combina em um roi só
	selectWindow(title);
	count = roiManager("count");
	array = newArray(count-1);
	for (i=0; i<array.length; i++) {
	  array[i] = i+1;
	}
	roiManager("select", array);
	roiManager("combine");
	roiManager("add");
	
	// seta medidas
	run("Set Measurements...", "area mean integrated display redirect=None decimal=3");
	
	// faz medidas e guarda em outro lugar
	count = roiManager("count");
	roiManager("select", count-1);
	roiManager("measure");
	
	// guarda os dados dos gh2ax_foci
	all_gh2ax_area = getResult("Area", 0);
	id_all_gh2axfoci = getResult("IntDen", 0);
	
	// mede os dados do núcleo todo
	roiManager("Select", 0);
	roiManager("measure");
	
	// guarda os dados do nucleo todo
	all_nucleus_area = getResult("Area", 1);
	id_gh2ax_nucleos = getResult("IntDen", 1);
	
	// adiocinar label como novo row
	if (isOpen("r2") == false) { 
		Table.create("r2");	
	}
	
	// seleciona nova tabela para guardar os dados
	selectWindow("r2");
	lastrow = Table.size;
	Table.set("label", Table.size, ori_title);
	Table.set("area_nucleo", lastrow, all_nucleus_area);
	Table.set("area_all_gh2ax_foci", lastrow, all_gh2ax_area);
	Table.set("id_gh2ax_nucleo", lastrow, id_gh2ax_nucleos);
	Table.set("id_gh2ax_foci", lastrow, id_all_gh2axfoci);
	Table.set("ratio_foci/n_area", lastrow, (all_gh2ax_area/all_nucleus_area)*100);
	Table.set("ratio_foci/n_id", lastrow, (id_all_gh2axfoci/id_gh2ax_nucleos)*100);
	
	//fechando o results window
	selectWindow("Results"); 
	run("Close");
	
	// salvando flatten
	selectWindow(title);
	run("Flatten");
	saveAs("Jpeg", input_path + "\\results-"+hoje+ "\\" + ori_title + ".jpg");
	
	//fecha todas as imagens
	close("*");
}
//salvando resultados
selectWindow("r2");
saveAs("results", input_path + "\\results-"+hoje+ "\\" + "resultados.csv");
run("Close All");