% Este programa mueve los resultados a una hoja de MS EXCEL

delta = 0.1;

fid = fopen('resultados/airy_C_ss.txt');      s  = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('resultados/airy_C_x_s.txt');     xs = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('resultados/airy_C_y_s.txt');     ys = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('resultados/airy_C_dph_dx.txt');  px = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('resultados/airy_C_dph_dy.txt');  py = str2num(fscanf(fid,'%c')); fclose(fid);
fid = fopen('resultados/airy_C_ph.txt');      p  = str2num(fscanf(fid,'%c')); fclose(fid);

p  = round(1e6*p)/1e6;
px = round(1e6*px)/1e6;
py = round(1e6*py)/1e6;

minxs = min(xs); maxxs = max(xs); posx = round((xs - minxs)/delta + 1);
minys = min(ys); maxys = max(ys); posy = round((ys - minys)/delta + 1);

ncol = round((maxxs-minxs)/delta + 1);
nfil = round((maxys-minys)/delta + 1);

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

xlswrite('ejemplo_C',matphi,  'airy', 'E7');
xlswrite('ejemplo_C',matphi_x,'airy', 'E47');
xlswrite('ejemplo_C',matphi_y,'airy', 'E87');

disp('Se han pasado los resultados a MS EXCEL!!!');
