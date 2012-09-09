/*
**Wole's aftercore Steel Organ Script**
(Shamelessly adapted from Weatherboy's felonia.ash)
http://kolmafia.us/showthread.php?t=
This is meant for aftercore, but could in theory be used in-run. 
*/

script "felonia.ash";
notify "Wole";
import <zlib.ash>;
string feloniaVersion = "0.03";		// This is the script's version!

//int Felonia_PAGE = 9999;
// check_version("Felonia", "Felonia", feloniaVersion, Felonia_PAGE);

//Various settings
setvar("woleUseMall", true); //in case you haven't used it

boolean useMall = vars["woleUseMall"].to_boolean();
string zapruder = "knoll.php?place=mayor";
string zapruderShroom;
boolean hasMusk = have_skill($skill[musk]);
boolean hasCantata = have_skill($skill[cantata]);
boolean hasSmooth = have_skill($skill[smooth]);
boolean hasSonata = have_skill($skill[sonata]);

//This checks for Combat modifier skills and casts/shrugs them
void combatModBuff(string rate){
	if (rate == "plus") {
		if (have_effect($effect[smooth movements]) > 0) {
			cli_execute("shrug smooth movements");
		}
		if (have_effect($effect[Sonata of Sneakiness]) > 0) {
			cli_execute("shrug Sonata of Sneakiness");
		}
		if (hasMusk && have_effect($effect[musk]) == 0){
			use_skill($skill[musk]);
		}
		if (hasCantata && have_effect($effect[cantata]) == 0){
			use_skill($skill[cantata]);
		}
	}
	if (rate == "minus") {
		if (have_effect($effect[musk]) > 0) {
			cli_execute("shrug musk");
		}
		if (have_effect($effect[cantata]) > 0) {
			cli_execute("shrug cantata");
		}
		if (hasSmooth && have_effect($effect[smooth movements]) == 0){
			use_skill($skill[smooth movement]);
		}
		if (hasSonata && have_effect($effect[sonata of sneakiness]) == 0){
			use_skill($skill[sonata of sneakiness]);
		}
	}
}

//This  runs adventures
void runAdv(location place) {
	if(my_adventures() >=1) {
		adventure(1, place);
	}
	else {
		print("Out of adventures","red");
		abort();
	}
}


//This acquires a pitchfork if necessary
void pitchfork() {
	print("Getting pitchfork", "blue");
	if (useMall && item_amount($item[annoying pitchfork]) == 0) {
		buy(1,$item[annoying pitchfork]);
	}
	if (!useMall && item_amount($item[annoying pitchfork]) == 0) {
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
	if (!useMall && item_amount($item[small leather glove]) == 0) {
		maximize("items",false);
			while (item_amount($item[small leather glove]) == 0) {
				combatModBuff("plus");
				runAdv($location[Spooky Gravy Barrow]);
		}
	}
	create(1, $item[spooky glove]);
}


//This acquires a mushroom and hands it in
void getAMushroom(string page) {
	print("Getting a mushroom and giving it to the mayor", "blue");
	foreach shroom in $strings[frozen,flaming,stinky] {
		if (contains_text(page, shroom)) {
			zapruderShroom = shroom;
		}
	}
	item questShroom = to_item(zapruderShroom +" mushroom");
	item questHatchling = to_item("pregnant "+ zapruderShroom +" mushroom");
	if (useMall && item_amount(questShroom) == 0) {
		buy(1, questShroom);
	}
	if (!useMall && item_amount(questShroom) == 0) {
		print("You need to grow a " + to_string(questShroom) + " to continue!");
		abort();
	}
	if (contains_text(visit_url(zapruder),to_string(questHatchling))) { 
		use(1, questHatchling);
	}
}

//This clears the barrow
void clearBarrow() {
	print("Starting the Spooky gravy barrow","blue");
	foreach shroom in $strings[spooky, sleazy,frozen,flaming,stinky] {
		familiar questFam = to_familiar(shroom + " gravy fairy");
		if (have_familiar(questFam)) {
			use_familiar(questFam);
			break;
		}
	}
	maximize("0.1 item -combat", false);
	set_property("choiceAdventure5",2);
	while(item_amount($item[inexplicably glowing rock]) == 0 || item_amount($item[spooky fairy gravy]) == 0) {
		combatModBuff("minus");
		runAdv($location[spooky gravy barrow]);
	}
	smallLeatherGlove();
	set_property("choiceAdventure5",1);
	maximize("-combat +equip spooky glove -tie", false);
	while (last_monster() != $monster[felonia]) {
		combatModBuff("minus");
		runAdv($location[spooky gravy barrow]);
	}
}

//Starts quests and does all the stuff
void main() {
	if (!knoll_available()) {
		print("You must be under a moon sign with Knoll access to do Felonia","red");
		abort();
	}
	visit_url(zapruder);
	pitchfork();
	getAMushroom(visit_url(zapruder));
	clearBarrow();
	visit_url(zapruder);
	print("Felonia quest complete!", "green");
}
