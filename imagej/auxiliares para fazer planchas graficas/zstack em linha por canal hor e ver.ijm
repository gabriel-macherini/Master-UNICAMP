// recorte o zoom desejado, remova os Z que você não quer, arrume cor e salve ele
// todos as imagens feitas vão ser salvas na mesma pasta da imagem de origem
// Gabriel Macherini Quaglia 01 abril 2022


nome_image = getTitle();
onde_esta = getInfo("image.directory");

selectWindow(nome_image);
run("Duplicate...", "title=copia1 duplicate");
run("Split Channels");


// ######### stack do canal 4 ##########
selectWindow("C4-copia1");
depth = nSlices;

run("RGB Color");
run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c4_horizontal.tif");
close();

selectWindow("C4-copia1");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c4_vertical.tif");
close();
selectWindow("C4-copia1");
close();


// ######### stack do canal 3 ##########
selectWindow("C3-copia1");
depth = nSlices;

run("RGB Color");
run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c3_horizontal.tif");
close();

selectWindow("C3-copia1");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c3_vertical.tif");
close();
selectWindow("C3-copia1");
close();

// ######### stack do canal 2 ##########
selectWindow("C2-copia1");
depth = nSlices;

run("RGB Color");
run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c2_horizontal.tif");
close();

selectWindow("C2-copia1");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c2_vertical.tif");
close();
selectWindow("C2-copia1");
close();

// ######### stack do canal 1 ##########
selectWindow("C1-copia1");
depth = nSlices;

run("RGB Color");
run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_horizontal.tif");
close();

selectWindow("C1-copia1");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_vertical.tif");
close();
selectWindow("C1-copia1");
close();


// ######## fazendo imagem com canal 1 e 2 #######
selectWindow(nome_image);
run("Duplicate...", "title=copia1 duplicate");
Stack.setActiveChannels("1100");

run("RGB Color", "slices keep");
rename("c1_c2");
depth = nSlices;

run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_c2_horizontal.tif");
close();

selectWindow("c1_c2");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_c2_vertical.tif");
close();
selectWindow("c1_c2");
close();

// ######## fazendo imagem com canal 1 e 3 #######
selectWindow("copia1");
Stack.setActiveChannels("1010");
run("RGB Color", "slices keep");

rename("c1_c3");
depth = nSlices;

run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_c3_horizontal.tif");
close();

selectWindow("c1_c3");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c1_c3_vertical.tif");
close();
selectWindow("c1_c3");
close();


// ######## fazendo imagem com canal 2 e 3 #######
selectWindow("copia1");
Stack.setActiveChannels("0110");
run("RGB Color", "slices keep");

rename("c2_c3");
depth = nSlices;

run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c2_c3_horizontal.tif");
close();

selectWindow("c2_c3");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_c2_c3_vertical.tif");
close();
selectWindow("c2_c3");
close();


// ######## fazendo imagem com canal 1, 2 e 3 #######
selectWindow("copia1");
Stack.setActiveChannels("1110");
run("RGB Color", "slices keep");

rename("3ch");
depth = nSlices;

run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_3ch_horizontal.tif");
close();

selectWindow("3ch");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_3ch_vertical.tif");
close();
selectWindow("3ch");
close();

// ######## fazendo imagem com canal 1, 2, 3 e 4 #######
selectWindow("copia1");
Stack.setActiveChannels("1111");
run("RGB Color", "slices keep");

rename("4ch");
depth = nSlices;

run("Make Montage...", "columns="+depth+" rows=1 scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(width-25, height-5, 1, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_4ch_horizontal.tif");
close();

selectWindow("4ch");
run("Make Montage...", "columns=1 rows="+depth+" scale=1 border=5");
width = getWidth;
height = getHeight;
makeRectangle(50, height-8, 2, 1);
run("Scale Bar...", "width=1 height=2 thickness=3 font=12 color=White background=None location=[At Selection] horizontal bold hide");
saveAs("Jpeg", onde_esta+ "\\" + "stack_4ch_vertical.tif");
close();
selectWindow("4ch");
close();

selectWindow("copia1");
close();
selectWindow(nome_image);
close();

