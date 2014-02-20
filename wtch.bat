cd scripts

start/b jitter coffee js -b

start/b watchify js/film/editIt.js --path js --noparse=FILE --dg false -s editIt -o dist/editIt.js

cd ../styles

start/b compass watch

cd ..

cd scripts/coffee/server

coffee serveTheatre.coffee