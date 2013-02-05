mkdir -p tmp/resize/
mkdir -p output/
mkdir -p tmp/wm/
for i in input/*.JPG;do
 name=$(echo $i|awk -F'/' '{print $2}');
 convert $i -resize 1440x900  tmp/resize/$name;
 composite -dissolve 50% -gravity center template/watermark.png tmp/resize/$name tmp/wm/$name
done;
 

for i in tmp/wm/*;do
  name=$(echo $i| awk -F'/' '{print $3}')
  convert -background "#27211b"  +append $i template/description.jpg  output/$name;
  codeXY=$(identify output/$name | awk '{print $3}' | awk -F'x' '{print "+"$1-180 "+" 65}');
  priceXY=$(identify output/$name | awk '{print $3}' | awk -F'x' '{print "+"$1-180 "+" 165}');
  code=$(cat input/prices.csv | grep $name | awk -F',' '{print $2}');
 
  price=$(cat input/prices.csv | grep $name | awk -F',' '{print  $3  }');  
  mogrify -fill white -pointsize 20 -annotate $codeXY $code -annotate $priceXY "Rs $price"  output/$name
 
done;
rm -rvf tmp/
