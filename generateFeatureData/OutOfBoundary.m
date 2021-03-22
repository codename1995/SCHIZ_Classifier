function ixFixOutofScreen = OutOfBoundary(fix_in, W, H)

bXOut = (fix_in.fix_x<0)|(fix_in.fix_x>W);
bYOut = (fix_in.fix_y<0)|(fix_in.fix_y>H);
ixFixOutofScreen = bXOut | bYOut;