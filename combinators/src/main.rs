use std::error::Error;

mod element;
use element::{Element, YN};

fn main() -> Result<(), Box<dyn Error>> {
    let mut v = element::load_as_v()?;

    assert_eq!(v.iter().count(), 118);

    //----------------------------------------------------------------------
    // easy
    //----------------------------------------------------------------------

    // count()
    let n = v.iter().count();
    assert_eq!(n, 118);

    // last()
    let last_element = v.iter().last().unwrap();
    assert_eq!(last_element.element, "Oganesson");

    // map

    // take()
    let first_2: Vec<_> = v.iter().take(2).map(|x| x.element.clone()).collect();
    assert_eq!(first_2, ["Hydrogen", "Helium"]);

    // take_while()
    let less_than_10e = v.iter().take_while(|x| x.number_of_neutrons <= 10);
    assert_eq!(less_than_10e.count(), 10);

    // nth()
    let uranium = v.iter().nth(91).unwrap();
    assert_eq!(uranium.element, "Uranium");


    // any()

    // all()

    // take()


    // by_ref

    // chain

    // cycle
    assert_eq!(v.iter().cycle().nth(120).unwrap().element, "Lithium");

    // find()
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

    // flat_map()

    Ok(())
}
