del skifoan.love
rmdir dist
mkdir dist
"C:\Program Files\7-Zip\7z.exe" a -r -tzip dist\skifoan.love @dist_files_list.txt
copy /b "C:\PortableApps\love-0.10.2-win64\love.exe"+dist\skifoan.love dist\skifoan.exe
copy "C:\PortableApps\love-0.10.2-win64\*.dll" dist\