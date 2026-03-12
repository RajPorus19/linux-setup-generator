# Build amfora from source using Go
git clone https://github.com/makew0rld/amfora /tmp/amfora-build
cd /tmp/amfora-build
go build -o amfora .
sudo mv amfora /usr/local/bin/amfora
rm -rf /tmp/amfora-build
