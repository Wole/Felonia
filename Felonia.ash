Shamelessly stolen from Weatherboy's felonia.ash

boolean useMall = vars["woleUseMall"];

string zapruder = "knoll.php?place=mayor";

//This  runs adventures
void runAdv(location place) {
}

//This acquires a pitchfork
void pitchfork() {
print("Getting pitchfork", "blue");
if (useMall && item_amount($item[annoying pitchfork]) == 0) {
buy(1,$item[annoying pitchfork]);
}
if (!useMall) {
while (item_amount($item[annoying pitchfork]) == 0) {
runAdv($location[bugbear pens]);
}
}
}

//This acquires a small leather glove if necessary and crafts a spooky glove
void smallLeatherGlove() {
print("Getting small leather glove", "blue");
if (useMall && item_amount($item[small leather glove]) == 0) {
buy(1,$item[small leather glove]);
}
if (!useMall) {
maximize("items",false);
while (item_amount($item[small leather glove]) == 0) {
runAdv($location[Spooky Gravy Barrow]);
}
}
create(1, $item[spooky glove]);
}


//This acquires a mushroom and hands it in
void getAMushroom(string page) {
print("Getting a mushroom and giving it to the mayor", "blue");
foreach string in $strings["frozen","flaming","stinky"] {
if (contains_text(page, string)) {
set_property("ZapruderShroom",string);
}
}
item questShroom = to_item(get_property("ZapruderShroom")+" mushroom");
item questHatchling = to_item("pregnant "+get_property("ZapruderShroom")+" mushroom");
if (useMall && item_amount(questShroom) == 0) {
buy(1, questShroom);
}
if (!useMall && item_amount(questShroom) == 0) {
print("You need to grow a " + to_string(questShroom) + "to continue!");
abort();
}
if (contains_text(visit_url(zapruder),to_string(questHatchling))) { 
use(1, questHatchling);
}
}

//This clears the barrow
void felonia() {
print("Starting the Spooky gravy barrow","blue");
//Equip suitable familiar and max 
foreach string in $strings["spooky", "sleazy","frozen","flaming","stinky"] {
familiar questFam = to_familiar(string + " gravy fairy");
if have_familiar(questFam) {
use_familiar(questFam);
break;
}
//MAX ITEMS && NONCOMS
//CHECK SONATA/SMOOTH & CAST

//Get glowing rock and spooky glove
set_property("choiceAdventure5",2);
while(item_amount($item[inexplicably glowing rock] == 0 && item_amount($item[spooky fairy gravy] == 0) {
runAdv($location[spooky gravy barrow]);
}
smallLeatherGlove();
//Set up gear & buffs and kills Felonia
set_property("choiceAdventure5",1);
//MAX NONCOMS +equip spooky glove
while (get_property(questM03Bugbear) {
runAdv($location[spooky gravy barrow]);
}

void main() {
if (!knoll_available()) {
print("you must be under a moon sign with Knoll access to do Felonia","red");
abort();
}
pitchfork();
getAMushroom();
felonia();
visit_url(zapruder);
print("Felonia quest complete!", "green");
}
