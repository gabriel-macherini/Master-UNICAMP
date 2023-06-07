// ----------------------------------------------------------------------------------------------------------------
// 						functions
// ----------------------------------------------------------------------------------------------------------------

function processChannels() {
// pt : Essa função da o auto contraste e coloca no meio dos cortes
    getDimensions(width, height, channels, slices, frames);
    
    for (i = 0; i < channels; i++) {
        Stack.setPosition(i, slices/2, 1);
        run("Enhance Contrast", "saturated=0.35");
    }
    
    Stack.setDisplayMode("composite");
    setLocation(-9, -1, screenWidth-9, screenHeight+5);
}

function extra_channels_removal() { 
// pt: remove os canais que cofocal e deixa só SR-SIM caso eles estiverem presentes
	getDimensions(width, height, channels, slices, frames);
	if (channels == 8) { //se tiver 8 canais, virar 4
		run("Arrange Channels...", "new=1357");
	}
	if (channels == 6) { //se tiver 6 canais, virar 3
		run("Arrange Channels...", "new=135");
	}
}

function save_jpg_tiff(dapiInPreview){
	input_path = getInfo("image.directory");
	previa_dir = File.isDirectory(input_path + "\\previa"); //cria string do novo diretório
	if (previa_dir == 0){ //cria o diretorio se ele não existir
		File.makeDirectory(input_path + "\\previa"); // cria resultado
	}
	img_title = getTitle();
	run("Z Project...", "projection=[Sum Slices]");
	if (channels == 4) { 
		Stack.setActiveChannels("1111");
        if (!dapiInPreview) {
            Stack.setActiveChannels("1110");
		}
	}
	if (channels == 3) { 
		Stack.setActiveChannels("111");
        if (!dapiInPreview) {
            Stack.setActiveChannels("110");
		}
	}
	getDimensions(width, height, channels, slices, frames);
    
    for (i = 0; i < channels; i++) {
        Stack.setPosition(i, slices/2, 1);
        run("Enhance Contrast", "saturated=0.35");
    }
	saveAs("Jpeg", input_path + "\\previa\\" + img_title + ".jpeg");
	saveAs("tiff", input_path + "\\previa\\" + img_title + ".tif");
}

// ----------------------------------------------------------------------------------------------------------------
//								code
// ----------------------------------------------------------------------------------------------------------------

input_path = getDirectory("input files"); //pega onde vai passar o código

// Create a dialog box
Dialog.create("Channel Colors");
Dialog.addMessage("Select colors for each channel:");

// Define the color choices array
colorChoices = newArray("Red", "Green", "Yellow", "Blue", "Magenta", "Grays", "Cyan");

// Add choices for channel colors
Dialog.addChoice("Channel 1:", colorChoices, "Blue");
Dialog.addChoice("Channel 2:", colorChoices, "Red");
Dialog.addChoice("Channel 3:", colorChoices, "Green");
Dialog.addChoice("Channel 4:", colorChoices, "Grays");

// Add a tickbox for "dapi in preview"
Dialog.addCheckbox("Dapi in preview images", false);

// Add a tickbox for "stop to preview"
Dialog.addCheckbox("Stop to look images", true);

// Display the dialog box
Dialog.show();

// Get the selected choices
channel1Color = Dialog.getChoice();
channel2Color = Dialog.getChoice();
channel3Color = Dialog.getChoice();
channel4Color = Dialog.getChoice();

// Process the selected channel colors
print("Channel 1 Color: " + channel1Color);
print("Channel 2 Color: " + channel2Color);
print("Channel 3 Color: " + channel3Color);
print("Channel 4 Color: " + channel4Color);

// Get the state of "dapi in preview" tickbox
dapiInPreview = Dialog.getCheckbox();
waitUserCheck = Dialog.getCheckbox();

filelist = getFileList(input_path); // armazena em uma variavel a lista de arquivos
for (f=0; f<filelist.length; f++) { //loop pra cada arquivo da lista de arquivo
	if (endsWith(filelist[f], ".czi") || endsWith(filelist[f], ".tiff") || endsWith(filelist[f], ".tif")) {

		// Rotina de fechar tudo, remover rois, abrir imagem e print no log
		run("Close All");
		anyROIs = roiManager("count");
		if (anyROIs > 0) {
		    roiManager("Deselect");
		    roiManager("Delete");
		}
		open(input_path + filelist[f]);
		print(input_path + filelist[f]);
		// fim da rotina
		
		
		extra_channels_removal();
		
		processChannels();
		
		getDimensions(width, height, channels, slices, frames);
		if (channels == 3) { 
			Stack.setChannel(1);
			run(channel1Color);
			Stack.setChannel(2);
			run(channel2Color);
			Stack.setChannel(3);
			run(channel3Color);
			if (dapiInPreview) {
			    Stack.setActiveChannels("111");
			} else {
			    Stack.setActiveChannels("110");
			}
		}
		if (channels == 4) { 
			Stack.setChannel(1);
			run(channel1Color);
			Stack.setChannel(2);
			run(channel2Color);
			Stack.setChannel(3);
			run(channel3Color);
			Stack.setChannel(4);
			run(channel4Color);
			if (dapiInPreview) {
			    Stack.setActiveChannels("1111");
			} else {
			    Stack.setActiveChannels("1110");
			}
		}
		if (waitUserCheck){	
			waitForUser("avaliação");
		}
		save_jpg_tiff(dapiInPreview);
	}
	
}

run("Close All");
print("Finished");