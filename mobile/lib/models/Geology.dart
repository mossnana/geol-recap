import 'dart:core';

const sedimentaryLithology = [
  {
    'name': 'Mudstone',
    'description': 'fine-grained, constituents were clays or muds',
  },
  {
    'name': 'Siltstone',
    'description': 'composed mainly of silt-sized particles'
  },
  {
    'name': 'Shale',
    'description': 'fine-grained, clastic sedimentary rock'
  },
  {
    'name': 'Sandstone',
    'description': 'clastic sedimentary rock composed mainly of sand-sized'
  },
  {
    'name': 'Limestone',
    'description': 'carbonate sedimentary rock that is often composed of the skeletal fragments of marine organisms such as coral, foraminifera, and molluscs.'
  },
  {
    'name': 'Marlstone',
    'description': 'calcium carbonate or lime-rich mud or mudstone which contains variable amounts of clays and silt'
  },
  {
    'name': 'Conglomerate',
    'description': 'coarse-grained clastic sedimentary rock'
  },
  {
    'name': 'Breccia',
    'description': 'rock composed of broken fragments of minerals or rock cemented together by a fine-grained matrix'
  },
  {
    'name': 'Coal',
    'description': 'combustible black or brownish-black sedimentary rock'
  },
  {
    'name': 'Other',
    'description': 'I can\'t identified it'
  },
];

const igneousLithology = [
  {
    'name': 'Phaneritic texture',
    'description': 'Rocks with mineral grains that are large enough to be identified by eye. slowly cooled intrusive',
  },
  {
    'name': 'Aphanitic texture',
    'description': 'Rocks with grain too small to be identified by eye. Rapidly solidified extruded magma and marginal facies of shallow intrusions'
  },
  {
    'name': 'Porphyritic texture',
    'description': 'Bimodal grain size distribution'
  },
  {
    'name': 'Glassy / amorphous',
    'description': 'No crystals formed'
  },
  {
    'name': 'Fragmental texture',
    'description': 'Pyroclastic rock, such as a tuff or volcanic breccia - Pyroclastic texture'
  },
  {
    'name': 'Vesicular texture',
    'description': 'Rocks characterized by abundant vesicles formed as a result of the expansion of gases during the fluid stage of the lava.'
  },
];

const grainSize = [
  {
    'name': 'Large boulder',
    'description': '> 6.3 cm',
  },
  {
    'name': 'Boulder',
    'description': '20 – 6.3 cm',
  },
  {
    'name': 'Cobble',
    'description': '6.3 – 20 cm',
  },
  {
    'name': 'Coarse gravel',
    'description': '2 – 6.3 cm',
  },
  {
    'name': 'Medium gravel',
    'description': '0.63 – 2 cm',
  },
  {
    'name': 'Fine gravel',
    'description': '2.0 – 6.3 mm',
  },
  {
    'name': 'Coarse sand',
    'description': '0.63 – 2.0 mm',
  },
  {
    'name': 'Medium sand',
    'description': '0.2 – 0.63 mm',
  },
  {
    'name': 'Fine sand',
    'description': '0.063 – 0.2 mm',
  },
  {
    'name': 'Coarse silt',
    'description': '0.02 – 0.063 mm',
  },
  {
    'name': 'Medium silt',
    'description': '0.0063 – 0.02 mm',
  },
  {
    'name': 'Fine silt',
    'description': '0.002 – 0.0063 mm',
  },
  {
    'name': 'Clay',
    'description': '< 0.002 mm',
  },
];

const sedimentaryStructures = [
  {
    'name': 'Sharp, Planar, Parallel',
    'description': 'assets/images/parallel.png',
  },
  {
    'name': 'Shape, Irregular',
    'description': 'assets/images/shape_irregular.png',
  },
  {
    'name': 'Nodular',
    'description': 'assets/images/nodular.png',
  },
  {
    'name': 'Gradational, Irregular',
    'description': 'assets/images/gradational.png',
  },
  {
    'name': 'Cross cutting, non parallel',
    'description': 'assets/images/cross_cutting.png',
  },
  {
    'name': 'Chaotic',
    'description': 'assets/images/chaotic.png',
  },
  {
    'name': 'Draping',
    'description': 'assets/images/draping.png',
  },
  {
    'name': 'Lenticular / Scour / channel',
    'description': 'assets/images/channel.png',
  },
  {
    'name': 'Wavy',
    'description': 'assets/images/wavy.png',
  },
  {
    'name': 'Wispy',
    'description': 'assets/images/wispy.png',
  },
  {
    'name': 'Sigmoidal',
    'description': 'assets/images/sigmoidal.png',
  },
  {
    'name': 'Massive',
    'description': '',
  },
  {
    'name': 'Normal Grading',
    'description': 'assets/images/normal_grading.png',
  },
  {
    'name': 'Reversed Grading',
    'description': 'assets/images/reverse_grading.png',
  },
  {
    'name': 'Ungrading',
    'description': 'assets/images/ungrading.png',
  },
];

const initFossils = [
  "Plant Trace fossils",
  "Faunal Trace fossils",
  "Bivalves",
  "Gastropods",
  "Cephalopods",
  "Branchiopods",
  "Echinoids",
  "Crinoids",
  "Corals",
  "Stromatolites",
  "Logs",
  "Tree Strupms",
  "Vertebrate Fossil",
];

const structureType = [
  {
    'title': '',
    'level': 6,
  },
  {
    'title': 'Primary Structure',
    'level': 1,
  },
  {
    'title': 'Bedding',
    'level': 3,
  },
  {
    'title': 'Secondary Structure',
    'level': 1,
  },
  {
    'title': 'Folds',
    'level': 2,
  },
  {
    'title': 'Parallel fold',
    'level': 3,
  },
  {
    'title': 'Harmonic fold',
    'level': 3,
  },
  {
    'title': 'Disharmonic fold',
    'level': 3,
  },
  {
    'title': 'Disharmonic fold',
    'level': 3,
  },
  {
    'title': 'Intrafoilal fold',
    'level': 3,
  },
  {
    'title': 'Ptymatic fold',
    'level': 3,
  },
  {
    'title': 'Chevron fold',
    'level': 3,
  },
  {
    'title': 'Isoclinal fold',
    'level': 3,
  },
  {
    'title': 'Polyclinal fold',
    'level': 3,
  },
  {
    'title': 'Foliation',
    'level': 2,
  },
  {
    'title': 'Slaty cleavage',
    'level': 3,
  },
  {
    'title': 'Crenulation cleavage',
    'level': 3,
  },
  {
    'title': 'Pressure solution cleavage',
    'level': 3,
  },
  {
    'title': 'Schistosity',
    'level': 3,
  },
  {
    'title': 'Mylonitic foliation',
    'level': 3,
  },
  {
    'title': 'Axial planar foliation',
    'level': 3,
  },
  {
    'title': 'Refracted foliations',
    'level': 3,
  },
  {
    'title': 'Fanning foliation',
    'level': 3,
  },
  {
    'title': 'Faults',
    'level': 2,
  },
  {
    'title': 'Normal fault',
    'level': 3,
  },
  {
    'title': 'Strike-slip fault',
    'level': 3,
  },
  {
    'title': 'Reverse fault',
    'level': 3,
  },
  {
    'title': 'Share zones',
    'level': 2,
  },
  {
    'title': 'Brittle shear zone',
    'level': 3,
  },
  {
    'title': 'Semi-brittle shear zone',
    'level': 3,
  },
  {
    'title': 'Ductile shear zone',
    'level': 3,
  },
  {
    'title': 'Brittle-ductile shear zone',
    'level': 3,
  },
  {
    'title': 'Others',
    'level': 2,
  },
  {
    'title': 'Joints',
    'level': 3,
  },
  {
    'title': 'Stylolites',
    'level': 3,
  },
];