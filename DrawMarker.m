function h = DrawMarker(pos,col)
d = 0.01;
hold on
h = plot3(pos(1)+[d 0 -d 0 d],pos(2)+[0 d 0 -d 0],pos(3)+[0 0 0 0 0],col);
