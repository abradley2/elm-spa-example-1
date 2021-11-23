if [ "$1" != "Main" ]; then
    elm make src/Document/$1.elm --optimize --output=assets/$1.bundle.js && \
    uglifyjs assets/$1.bundle.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output assets/$1.bundle.js
else
    elm make src/$1.elm --optimize --output=assets/$1.bundle.js && \
    uglifyjs assets/$1.bundle.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output assets/$1.bundle.js
fi

# gzip -f assets/$1.bundle.js -c > assets/$1.bundle.js.gz
