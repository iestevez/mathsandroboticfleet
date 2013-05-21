MAXBYTES=3;
client = socket(AF_INET, SOCK_STREAM, 0);
server_info = struct("addr", "127.0.0.1", "port", 4000);
rc = connect(client, server_info);
i=1;
[rec_ans,count]= recv(client,MAXBYTES);
rec=[];
while(count>0)
  rec=[rec,rec_ans];
  [rec_ans,count]= recv(client,MAXBYTES);
endwhile
if(length(rec)>0)
eval(char(rec),disp("Error en el código recibido"));
else
disp("No se recibió código");
endif
