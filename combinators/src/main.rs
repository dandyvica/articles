
use std::error::Error;

mod element;
use element::{Element, YN};

fn main() -> Result<(), Box<dyn Error>> {
    let mut v = element::load_as_vector()?;



	pub fn load_as_vector() -> Result<Vec<Element>, Box<dyn Error>> {
	// load CSV
	let reader = std::fs::File::open("elements.csv").unwrap();
	let mut rdr = csv::Reader::from_reader(reader);
	
	// create a vector of structs
	let mut v: Vec<Element> = Vec::new();
	
	for result in rdr.deserialize() {
	let record: Element = result?;
	v.push(record);
	}
	
	Ok(v)
	}


	let v = element::load_as_vector()?;


	let n = v.iter().count();
	assert_eq!(n, 118);


	let last_element = v.iter().last().unwrap();
	assert_eq!(last_element.element, "Oganesson");


	let uranium = v.iter().nth(91).unwrap();
	assert_eq!(uranium.element, "Uranium");
	assert!(v.iter().nth(118).is_none());


	let mut mapped = v
	.iter()
	.map(|x| (x.atomic_number, x.element.as_ref(), x.symbol.as_ref()));
	assert_eq!(mapped.nth(5).unwrap(), (6u8, "Carbon", "C"));


	let names: Vec<_> = v.iter().map(|x| &x.element).collect();
	assert_eq!(names[0..2], ["Hydrogen", "Helium"]);


	let first_2: Vec<_> = v.iter().take(2).map(|x| x.element.clone()).collect();
	assert_eq!(first_2, ["Hydrogen", "Helium"]);


	let less_than_10e = v.iter().take_while(|x| x.number_of_neutrons <= 10);
	assert_eq!(less_than_10e.count(), 10);


	assert!(v.iter().any(|x| x.number_of_neutrons > 50));


	assert!(v.iter().all(|x| x.symbol.len() == 1 || x.symbol.len() == 2));


	assert_eq!(v.iter().cycle().nth(120).unwrap().element, "Lithium");


	let helium = v.iter().find(|x| x.element.ends_with("ium")).unwrap();
	assert_eq!(helium.element, "Helium");


	let gases: Vec<_> = v.iter().filter(|x| x.phase == "gas").collect();
	assert_eq!(gases.iter().count(), 11);
	v.iter()
	.filter(|x| x.phase == "gas")
	.for_each(|x| println!("{:?}", x.element));
	// gives:
	// "Hydrogen"
	// "Helium"
	// "Nitrogen"
	// "Oxygen"
	// "Fluorine"
	// "Neon"
	// "Chlorine"
	// "Argon"
	// "Krypton"
	// "Xenon"
	// "Radon"


	let radioactives: Vec<_> = v
	.iter()
	.filter_map(|x| x.radioactive.as_ref())
	.filter(|x| **x == YN::yes)
	.collect();
	assert_eq!(radioactives.iter().count(), 37);


	let (i, _) = v.iter().enumerate().last().unwrap();
	assert_eq!(i, 117);


	let first_non_gas = v.iter().skip_while(|x| x.phase == "gas" ).next().unwrap();
	assert_eq!(first_non_gas.element, "Lithium");


	let neutrons = v.iter().map(|x| x.number_of_neutrons);
	let protons = v.iter().map(|x| x.number_of_protons);
	let mass_numbers: Vec<_> = neutrons.zip(protons).map(|(x, y)| x + y).collect();
	assert_eq!(mass_numbers[91], 238);


	let all_gases = v.iter().filter(|x| x.phase == "gas");
	let all_solids = v.iter().filter(|x| x.phase == "solid");
	let gases_and_solids: Vec<_> = all_solids.chain(all_gases).collect();
	assert_eq!(gases_and_solids.iter().nth(0).unwrap().element, "Lithium");
	assert_eq!(gases_and_solids.iter().last().unwrap().element, "Radon");


	let potassium = v.iter().position(|x| x.element == "Potassium").unwrap();
	assert_eq!(v[potassium].symbol, "K");


	let last_gas = v.iter().rposition(|x| x.phase == "gas").unwrap();
	assert_eq!(v[last_gas].element, "Radon");


	use std::cmp::Ordering;
	let cmp = |x: &Element, y: &Element| -> Ordering {
	if x.atomic_mass < y.atomic_mass {
	Ordering::Less
	} else if x.atomic_mass > y.atomic_mass {
	Ordering::Greater
	} else {
	Ordering::Equal
	}
	};
	
	let heaviest = v
	.iter()
	.filter(|x| x.phase != "artificial")
	.max_by(|x, y| cmp(x, y))
	.unwrap();
	assert_eq!(heaviest.symbol, "U");


	let hydrogen = v.iter().rev().last().unwrap();
	assert_eq!(hydrogen.symbol, "H");


	let longuest = v.iter().max_by_key(|x| x.element.len()).unwrap();
	assert_eq!(longuest.element, "Rutherfordium");


	//use std::cmp::Ordering;
	
	impl Ord for Element {
	fn cmp(&self, other: &Self) -> Ordering {
	if self.year < other.year {
	Ordering::Less
	} else if self.year > other.year {
	Ordering::Greater
	} else {
	Ordering::Equal
	}
	}
	}
	
	impl PartialOrd for Element {
	fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
	Some(self.cmp(other))
	}
	}
	
	impl PartialEq for Element {
	fn eq(&self, other: &Self) -> bool {
	self.year == other.year
	}
	}
	
	impl Eq for Element {}
	
	let first_discovered = v.iter().min().unwrap();
	assert_eq!(first_discovered.element, "Carbon");
	let last_discovered = v.iter().max().unwrap();
	assert_eq!(last_discovered.element, "Tennessine");
Ok(())}
