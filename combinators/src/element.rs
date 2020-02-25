use std::error::Error;

use serde::Deserialize;

#[allow(non_camel_case_types)]
#[derive(Debug, PartialEq, Deserialize)]
pub enum YN {
    yes,
    no,
}

#[allow(non_snake_case)]
#[derive(Debug, Deserialize)]
pub struct Element {
    pub atomic_number: u8,
    pub element: String,
    pub symbol: String,
    pub atomic_mass: f32,
    pub number_of_neutrons: u8,
    pub number_of_protons: u8,
    pub number_of_electrons: u8,
    pub period: u8,
    pub group: Option<u8>,
    pub phase: String,
    pub radioactive: Option<YN>,
    pub natural: Option<YN>,
    pub metal: Option<YN>,
    pub non_metal: Option<YN>,
    pub metalloid: Option<YN>,
    pub r#type: String,
    pub atomic_radius: Option<f32>,
    pub electro_negativity: Option<f32>,
    pub first_ionization: Option<f32>,
    pub density: Option<f32>,
    pub melting_point: Option<f32>,
    pub boiling_point: Option<f32>,
    pub number_of_isotopes: Option<u8>,
    pub discoverer: Option<String>,
    pub year: Option<u16>,
    pub specific_heat: Option<f32>,
    pub number_of_shells: Option<u8>,
    pub number_of_valence: Option<u8>,
}

pub fn load_as_v() -> Result<Vec<Element>, Box<dyn Error>> {
    // load CSV
    let reader = std::fs::File::open("elements.csv").unwrap();
    let mut rdr = csv::Reader::from_reader(reader);

    // hash and v
    let mut v: Vec<Element> = Vec::new();

    for result in rdr.deserialize() {
        let record: Element = result?;
        //println!("{:?}", record);
        v.push(record);
    }
    //println!("{:?}", v);

    Ok(v)
}
