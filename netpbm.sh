#!/bin/bash

cat > mask <<EOF
P2
3 3
32
14 14 14 
14 48 14
14 14 14
EOF

tifftopnm $1 | \
	pnmcut -left 100 -right -100 -top 100 -bottom -100 | \
	pnmscale 0.9 | \
	pnmconvol mask | \
	pnmtotiff -truecolor -color > $2
