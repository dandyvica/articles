use std::error::Error;

mod element;
use element::{Element, YN};

fn main() -> Result<(), Box<dyn Error>> {
    let mut v = element::load_as_v()?;

    assert_eq!(v.iter().count(), 118);

    //----------------------------------------------------------------------
    // easy
    //----------------------------------------------------------------------

    // count(): get the number of natural elements
    let n = v.iter().count();
    assert_eq!(n, 118);

    // last(): which is the last element's name ?
    let last_element = v.iter().last().unwrap();
    assert_eq!(last_element.element, "Oganesson");

    // nth(): Uranium is the 92th element (vector is indexing from 0)
    let uranium = v.iter().nth(91).unwrap();
    assert_eq!(uranium.element, "Uranium");
    assert!(v.iter().nth(300).is_none());

    // map(): create a new vector with Element's type fields
    let mut mapped = v.iter().map(|x| (x.atomic_number, &x.element, &x.symbol));
    //assert_eq!(mapped.nth(5).unwrap(), (1, "Carbon".to_string(), "C".to_string()));

    // take(): returns the first n-elements
    let first_2: Vec<_> = v.iter().take(2).map(|x| x.element.clone()).collect();
    assert_eq!(first_2, ["Hydrogen", "Helium"]);

    // skip()

    // take_while()
    let less_than_10e = v.iter().take_while(|x| x.number_of_neutrons <= 10);
    assert_eq!(less_than_10e.count(), 10);

    // any(): there's at least one element with more thant 50 electrons
    assert!(v.iter().any(|x| x.number_of_neutrons > 50));

    // all(): all elements have their symbol composed by 1 or 2 letters (e.g.: C or Na)
    assert!(v.iter().all(|x| x.symbol.len() == 1 || x.symbol.len() == 2));

    // by_ref
    //let by_ref = v.iter().by_ref().

    // cycle(): loops endlessly on an iterator.
    assert_eq!(v.iter().cycle().nth(120).unwrap().element, "Lithium");

    // find(): Helium is the first element whose name ends with "ium"
    let helium = v.iter().find(|x| x.element.ends_with("ium")).unwrap();
    assert_eq!(helium.element, "Helium");

    // filter() is an iterator
    // filt
    let gases: Vec<_> = v.iter().filter(|x| x.phase == "gas").collect();
    assert_eq!(gases.iter().count(), 11);
    v.iter()
        .filter(|x| x.phase == "gas")
        .for_each(|x| println!("{:?}", x.element));

    // filter_map() allows to filter only those retruning Some
    let radioactives: Vec<_> = v
        .iter()
        .filter_map(|x| x.radioactive.as_ref())
        .filter(|x| **x == YN::yes)
        .collect();
    assert_eq!(radioactives.iter().count(), 37);

    // zip(): combines 2 iterators like a zip giving another iterator
    let neutrons = v.iter().map(|x| x.number_of_neutrons);
    let protons = v.iter().map(|x| x.number_of_protons);
    let mass_numbers: Vec<_> = neutrons.zip(protons).map(|(x,y)| x+y).collect();

    // chain(): 
    let all_gases = v.iter().filter(|x| x.phase == "gas");
    let all_solids = v.iter().filter(|x| x.phase == "solid");
    let gases_and_solids: Vec<_> = all_solids.chain(all_gases).collect();
    assert_eq!(gases_and_solids.iter().nth(0).unwrap().element, "Lithium");
    assert_eq!(gases_and_solids.iter().last().unwrap().element, "Radon");

    // flat_map()

    // fuse()
    //let fuse = v.iter()

    // position(): searches for the Potassium element
    let potassium = v.iter().position(|x| x.element == "Potassium").unwrap();
    assert_eq!(v[potassium].symbol, "K");

    // rposition(): which is the last gas in the Mendeleiv table ?
    let last_gas = v.iter().rposition(|x| x.phase == "gas").unwrap();
    assert_eq!(v[last_gas].element, "Radon");

    // max_by(): which is the heaviest non-artificial element ? Uranium !
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

    // last(): obvious !
    let hydrogen = v.iter().rev().last().unwrap();
    assert_eq!(hydrogen.symbol, "H");

    // max_by_key(): longuest element's name is Rutherfordium
    let longuest = v.iter().max_by_key(|x| x.element.len()).unwrap();
    assert_eq!(longuest.element, "Rutherfordium");

    //  partition(): 
    //let (gases, non_gases): (Vec<Element>, Vec<Element>) = v.iter().by_ref().partition(|x| x.phase.as_ref() == "gas");

    // Some others are quite easy to understand like step_by()

    Ok(())
}
