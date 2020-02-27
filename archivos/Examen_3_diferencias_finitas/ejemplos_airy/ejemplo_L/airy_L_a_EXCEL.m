% Este programa mueve los resultados a una hoja de MS EXCEL

delta = 0.1;

fid = fopen('airy_L_ss.txt');      s  = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_x_s.txt');     xs = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_y_s.txt');     ys = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_dph_dx.txt');  px = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_dph_dy.txt');  py = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('airy_L_ph.txt');      p  = str2num(fscanf(fid,'%c')); fclose(fid);

p  = round(1e6*p)/1e6;
px = round(1e6*px)/1e6;
py = round(1e6*py)/1e6;

minxs = min(xs); maxxs = max(xs); posx = round((xs - minxs)/delta + 1);
minys = min(ys); maxys = max(ys); posy = round((ys - minys)/delta + 1);

ncol = (maxxs-minxs)/delta + 1;
nfil = (maxys-minys)/delta + 1;

matphi   = nan(nfil,ncol);
matphi_x = nan(nfil,ncol);
matphi_y = nan(nfil,ncol);

for i = 1:length(s)
   matphi  (posy(i),posx(i)) = p(i);
   matphi_x(posy(i),posx(i)) = px(i);
   matphi_y(posy(i),posx(i)) = py(i);
end

matphi   = flipud(matphi);
matphi_x = flipud(matphi_x);
matphi_y = flipud(matphi_y);

xlswrite('ejemplo_clase_L',matphi,  'airy', 'D5');
xlswrite('ejemplo_clase_L',matphi_x,'airy', 'D45');
xlswrite('ejemplo_clase_L',matphi_y,'airy', 'D85');

disp('Terminé de pasar los resultados a MS EXCEL!!!');