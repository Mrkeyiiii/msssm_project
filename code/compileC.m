checkFolder = exist('bin','dir');
if checkFolder ~= 7
    mkdir('bin')
end

mex -output 'bin/fastSweeping' 'c/fastSweeping.c'
mex -output 'bin/getNormalizedGradient' 'c/getNormalizedGradient.c'
mex -output 'bin/lerp2' 'c/lerp2.c'
mex -output 'bin/createRangeTree' 'c/createRangeTree.c'
mex -output 'bin/rangeQuery' 'c/rangeQuery.c'