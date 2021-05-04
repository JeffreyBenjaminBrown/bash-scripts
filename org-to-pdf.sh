sed -r "s/^\*/\n#/g" $1 > $1.md
sed -i -r "s/^#\*/##/g" $1.md
sed -i -r "s/^##\*/###/g" $1.md
sed -i -r "s/^###\*/####/g" $1.md
sed -i -r "s/^####\*/#####/g" $1.md
sed -i -r "s/^#####\*/######/g" $1.md
sed -i -r "s/^######\*/#######/g" $1.md

pandoc -o $1.pdf $1.md
