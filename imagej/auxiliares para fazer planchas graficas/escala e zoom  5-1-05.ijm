// Selecione a Area que deve ser desenhanda em volta o quadrado branco e salve como o primeiro ROI no roi manager
// selecione o código que deseja e rode somente essa porção do código usando ctrl+shift+R



// ----------------------------------------------------------------------------------------------------------------
// 						5µm
// ----------------------------------------------------------------------------------------------------------------


// zoom em celula toda de 5µm

run("RGB Color", "slices keep");

run("Scale Bar...", "width=5.0 height=5 thickness=18 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");

setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);

roiManager("Select", 0);

run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");




// ----------------------------------------------------------------------------------------------------------------
// 						1µm
// ----------------------------------------------------------------------------------------------------------------


// zoom do zoom toda de 1µm

run("RGB Color", "slices keep");

run("Scale Bar...", "width=1.0 height=1 thickness=14 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");

setForegroundColor(255, 255, 255);
setBackgroundColor(0, 0, 0);

roiManager("Select", 0);

run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");


// ----------------------------------------------------------------------------------------------------------------
// 						0.5µm
// ----------------------------------------------------------------------------------------------------------------

// zoom do zoom   0.5µm

run("RGB Color", "slices keep")
run("Scale Bar...", "width=0.5 height=1 thickness=6 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");




// tamanho padrao do quadrado de imagem de núcleo

// ----------------------------------------------------------------------------------------------------------------
// 						900x900 selecao de quadrado
// ----------------------------------------------------------------------------------------------------------------

makeRectangle(1, 1, 900, 900);


// ----------------------------------------------------------------------------------------------------------------
// 						700x700 selecao de quadrado
// ----------------------------------------------------------------------------------------------------------------

makeRectangle(1, 1, 700, 700);

// ----------------------------------------------------------------------------------------------------------------
// 						desenha quadrado envolta da área selecionada com grossura de 4 pixeis
// ----------------------------------------------------------------------------------------------------------------


run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");
run("Enlarge...", "enlarge=1 pixel");
run("Draw", "slice");


// ----------------------------------------------------------------------------------------------------------------
// 						6 primeiros do zstack em linha horizontal
// ----------------------------------------------------------------------------------------------------------------


run("RGB Color");
run("Make Montage...", "columns=6 rows=1 scale=1 border=5");
run("Scale Bar...", "width=5 height=5 thickness=8 font=32 color=White background=None location=[Lower Right] horizontal bold overlay")








