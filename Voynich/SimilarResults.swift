//
//  SimilarResults.swift
//  Voynich
//
//  Created by Torsten Timm on 21.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import Foundation

/// the results for calcDistances("chol") (to improve perfomance)
let chol_distanceMap: Dictionary<String, Int> = [
    "shol" : 1,
    "shod" : 2,
    "otchol" : 2,
    "chor" : 1,
    "cfhol" : 1,
    "ol" : 2,
    "chol" : 0,
    "chal" : 1,
    "sho" : 2,
    "kchom" : 2,
    "ycho" : 2,
    "pshol" : 2,
    "cthols" : 2,
    "cpho" : 2,
    "chy" : 2,
    "cthal" : 2,
    "cthol" : 1,
    "**chol" : 2,
    "chtor" : 2,
    "chok" : 2,
    "char" : 2,
    "dcho" : 2,
    "chody" : 2,
    "ckho" : 2,
    "cphoal" : 2,
    "chodo" : 2,
    "cheol" : 1,
    "shor" : 2,
    "dchor" : 2,
    "ypchol" : 2,
    "chtod" : 2,
    "dchol" : 1,
    "ckhor" : 2,
    "cthor" : 2,
    "cheo" : 2,
    "pchor" : 2,
    "kcho" : 2,
    "cholo" : 1,
    "cheor" : 2,
    "kchor" : 2,
    "chr" : 2,
    "cham" : 2,
    "ochor" : 2,
    "cho" : 1,
    "cthom" : 2,
    "chom" : 1,
    "shom" : 2,
    "pcheol" : 2,
    "sheol" : 2,
    "opchol" : 2,
    "cphor" : 2,
    "ckhol" : 1,
    "kcheol" : 2,
    "tchor" : 2,
    "choldy" : 2,
    "chols" : 1,
    "cholor" : 2,
    "cphol" : 1,
    "ychol" : 1,
    "chory" : 2,
    "ychor" : 2,
    "ckhal" : 2,
    "ocholy" : 2,
    "chald" : 2,
    "kchod" : 2,
    "rcho" : 2,
    "scho" : 2,
    "sol" : 2,
    "choor" : 2,
    "ocho" : 2,
    "chot" : 2,
    "chotol" : 2,
    "ctho" : 2,
    "cholal" : 2,
    "chl" : 1,
    "cha" : 2,
    "schol" : 1,
    "cthod" : 2,
    "cheal" : 2,
    "dshol" : 2,
    "kchol" : 1,
    "okchol" : 2,
    "choly" : 1,
    "tchol" : 1,
    "choy" : 2,
    "qochol" : 2,
    "tshol" : 2,
    "schoal" : 2,
    "chodl" : 1,
    "schold" : 2,
    "chodal" : 2,
    "chopol" : 2,
    "fchol" : 1,
    "chod" : 1,
    "chtols" : 2,
    "ctholy" : 2,
    "chos" : 2,
    "cthl" : 2,
    "*chor" : 2,
    "cphod" : 2,
    "sholo" : 2,
    "chop" : 2,
    "ycheol" : 2,
    "ctheol" : 2,
    "chkor" : 2,
    "cheeol" : 2,
    "ykchol" : 2,
    "chlol" : 1,
    "dchal" : 2,
    "ochol" : 1,
    "dchod" : 2,
    "cholol" : 2,
    "ckholy" : 2,
    "tcho" : 2,
    "chtol" : 1,
    "lchol" : 1,
    "fcholy" : 2,
    "ctholo" : 2,
    "schor" : 2,
    "chdoly" : 2,
    "cphal" : 2,
    "kchorl" : 2,
    "ytchol" : 2,
    "ofchol" : 2,
    "kshol" : 2,
    "octhol" : 2,
    "tochol" : 2,
    "pcho" : 2,
    "tchols" : 2,
    "chals" : 2,
    "chof" : 2,
    "shkol" : 2,
    "pchol" : 1,
    "cheod" : 2,
    "ychom" : 2,
    "cthold" : 2,
    "chyd" : 2,
    "chkol" : 1,
    "chokol" : 2,
    "cheom" : 2,
    "fcho" : 2,
    "ctol" : 2,
    "shal" : 2,
    "chdal" : 2,
    "chd" : 2,
    "cholky" : 2,
    "lchal" : 2,
    "co" : 2,
    "fchom" : 2,
    "chon" : 2,
    "sholy" : 2,
    "chshol" : 2,
    "chls" : 2,
    "fchor" : 2,
    "chkal" : 2,
    "yshol" : 2,
    "shols" : 2,
    "cholty" : 2,
    "pchdol" : 2,
    "choal" : 1,
    "lchor" : 2,
    "chko" : 2,
    "pchom" : 2,
    "chotal" : 2,
    "chad" : 2,
    "tchod" : 2,
    "chdor" : 2,
    "tcheol" : 2,
    "chodr" : 2,
    "dcheol" : 2,
    "oshol" : 2,
    "ycthol" : 2,
    "tchom" : 2,
    "dchom" : 2,
    "kcholy" : 2,
    "ckheol" : 2,
    "cphom" : 2,
    "ockhol" : 2,
    "chpal" : 2,
    "pchal" : 2,
    "kchal" : 2,
    "ckchol" : 2,
    "chorol" : 2,
    "cholfy" : 2,
    "cholar" : 2,
    "cheoly" : 2,
    "chaly" : 2,
    "dcholy" : 2,
    "chokal" : 2,
    "tcholy" : 2,
    "chodol" : 2,
    "choar" : 2,
    "*shol" : 2,
    "cheyl" : 2,
    "chso" : 2,
    "chpor" : 2,
    "cheoal" : 2,
    "ch" : 2,
    "ocheol" : 2,
    "cholam" : 2,
    "archol" : 2,
    "chly" : 2,
    "lkchol" : 2,
    "cheols" : 2,
    "alchol" : 2,
    "chsor" : 2,
    "shtol" : 2,
    "chdol" : 1,
    "shl" : 2,
    "chlr" : 2,
    "tchal" : 2,
    "chedol" : 2,
    "lcheol" : 2,
    "chtal" : 2,
    "lchl" : 2,
    "sshol" : 2,
    "chepol" : 2,
    "ckol" : 2,
    "*cheol" : 2,
    "shdol" : 2,
    "lchdol" : 2,
    "chekol" : 2,
    "techol" : 2,
    "scheol" : 2,
    "cfheol" : 2,
    "chool" : 1,
    "cpheol" : 2,
    "eol" : 2,
    "ckhod" : 2,
    "kchdol" : 2,
    "csol" : 2,
    "cholp" : 1,
    "pcholy" : 2,
    "chofol" : 2,
    "rchol" : 1,
    "chym" : 2,
    "chalr" : 2,
    "chllo" : 2,
    "cheodl" : 2,
    "cholxy" : 2,
    "qchor" : 2,
    "lcho" : 2,
    "chlal" : 2,
    "pchod" : 2,
    "chtl" : 2,
    "chalg" : 2,
    "fcheol" : 2,
    "chdo" : 2,
    "lchod" : 2,
    "rchl" : 2,
    "chlor" : 2,
    "chll" : 2,
]

/// the results for calcDistances("dain") (to improve perfomance)
var dain_distanceMap: Dictionary<String, Int> = [
    "dan" : 1,
    "daiin" : 1,
    "dair" : 1,
    "dain" : 0,
    "ydain" : 1,
    "oldain" : 2,
    "odaiin" : 2,
    "dasain" : 2,
    "daiiin" : 2,
    "*doin" : 2,
    "dar" : 2,
    "daind" : 1,
    "daiiny" : 2,
    "kydain" : 2,
    "an" : 2,
    "aiin" : 2,
    "doiin" : 2,
    "daiir" : 2,
    "ydaiin" : 2,
    "sain" : 2,
    "dais" : 1,
    "daird" : 2,
    "raiin" : 2,
    "daim" : 2,
    "doaiin" : 2,
    "dairo" : 2,
    "da" : 2,
    "kain" : 2,
    "dainod" : 2,
    "dairin" : 2,
    "ydair" : 2,
    "*ain" : 2,
    "tdaiin" : 2,
    "dait" : 2,
    "dydain" : 2,
    "daing" : 1,
    "odain" : 1,
    "daid" : 2,
    "dein" : 2,
    "dchain" : 2,
    "ain" : 1,
    "deaiin" : 2,
    "daiis" : 2,
    "dairy" : 2,
    "rair" : 2,
    "odan" : 2,
    "orain" : 2,
    "chdain" : 2,
    "air" : 2,
    "dainl" : 1,
    "dainor" : 2,
    "todain" : 2,
    "laiin" : 2,
    "pdair" : 2,
    "das" : 2,
    "dalain" : 2,
    "dorain" : 2,
    "oain" : 2,
    "dairl" : 2,
    "dail" : 2,
    "lain" : 1,
    "tedain" : 2,
    "qodain" : 2,
    "dariin" : 2,
    "daiino" : 2,
    "tain" : 2,
    "kodain" : 2,
    "odair" : 2,
    "olain" : 2,
    "pdaiin" : 2,
    "ldaiin" : 2,
    "ainy" : 2,
    "rain" : 1,
    "ais" : 2,
    "eain" : 2,
    "doair" : 2,
    "alain" : 2,
    "in" : 2,
    "daein" : 1,
    "ltain" : 2,
    "dainy" : 1,
    "lkain" : 2,
    "doin" : 1,
    "oin" : 2,
    "dytain" : 2,
    "dykain" : 2,
    "dkain" : 1,
    "rtain" : 2,
    "tdain" : 1,
    "ldain" : 1,
    "pdan" : 2,
    "daisin" : 2,
    "daisn" : 1,
    "daindl" : 2,
    "rais" : 2,
    "dyaiin" : 2,
    "loain" : 2,
    "dyair" : 2,
    "arain" : 2,
    "lair" : 2,
    "dkair" : 2,
    "rodain" : 2,
    "lrain" : 2,
]

/// the results for calcDistances("daiin") (to improve perfomance)
var daiin_distanceMap: Dictionary<String, Int> = [
    "dan" : 2,
    "daraiin" : 2,
    "daiin" : 0,
    "dair" : 2,
    "dain" : 1,
    "ydain" : 2,
    "kodaiin" : 2,
    "oiin" : 2,
    "odaiin" : 1,
    "daiiin" : 1,
    "kaiin" : 2,
    "dchaiin" : 2,
    "saiin" : 2,
    "daind" : 2,
    "daiiny" : 1,
    "qodaiin" : 2,
    "aiin" : 1,
    "daiim" : 2,
    "doiin" : 1,
    "pydaiin" : 2,
    "oaiin" : 2,
    "daiir" : 1,
    "taiin" : 2,
    "ydaiin" : 1,
    "yodaiin" : 2,
    "dais" : 2,
    "raiin" : 1,
    "oraiin" : 2,
    "doiir" : 2,
    "rodaiin" : 2,
    "paiin" : 2,
    "doaiin" : 1,
    "sodaiin" : 2,
    "dtoaiin" : 2,
    "dairin" : 1,
    "olaiin" : 2,
    "oldaiin" : 2,
    "diiin" : 2,
    "tdaiin" : 1,
    "shdaiin" : 2,
    "daiinol" : 2,
    "odaiir" : 2,
    "doiiin" : 2,
    "todaiin" : 2,
    "dykaiin" : 2,
    "daing" : 2,
    "odain" : 2,
    "ain" : 2,
    "*aiin" : 2,
    "haiin" : 2,
    "odaiiin" : 2,
    "deaiin" : 1,
    "aiir" : 2,
    "daiis" : 1,
    "alaiin" : 2,
    "loiin" : 2,
    "lodaiin" : 2,
    "aiiin" : 2,
    "chdaiin" : 2,
    "dainl" : 2,
    "roaiin" : 2,
    "gaiin" : 2,
    "laiin" : 1,
    "daiiiny" : 2,
    "ordaiin" : 2,
    "aiis" : 2,
    "yaiin" : 2,
    "daiiry" : 2,
    "dodaiin" : 2,
    "lain" : 2,
    "daiiy" : 2,
    "podaiin" : 2,
    "ariin" : 2,
    "dariin" : 1,
    "tedaiin" : 2,
    "daiino" : 1,
    "oedaiin" : 2,
    "aldaiin" : 2,
    "pdaiin" : 1,
    "ldaiin" : 1,
    "dalaiin" : 2,
    "rain" : 2,
    "aiiny" : 2,
    "dolaiin" : 2,
    "dasaiin" : 2,
    "daein" : 2,
    "yiin" : 2,
    "dainy" : 2,
    "raiiin" : 2,
    "ylaiin" : 2,
    "lkaiin" : 2,
    "doin" : 2,
    "roiin" : 2,
    "ltaiin" : 2,
    "doraiin" : 2,
    "daiil" : 2,
    "dkain" : 2,
    "doiis" : 2,
    "tdain" : 2,
    "daiinls" : 2,
    "araiin" : 2,
    "o*daiin" : 2,
    "opdaiin" : 2,
    "ldaiiin" : 2,
    "odoiin" : 2,
    "ldain" : 2,
    "daiiine" : 2,
    "aii" : 2,
    "daiindy" : 2,
    "daisin" : 1,
    "odariin" : 2,
    "daisn" : 2,
    "fodaiin" : 2,
    "sedaiin" : 2,
    "lsaiin" : 2,
    "dyaiin" : 1,
    "raiis" : 2,
    "laiiin" : 2,
    "odeaiin" : 2,
    "lraiin" : 2,
    "lpaiin" : 2,
    "qedaiin" : 2,
    "qaiin" : 2,
    "diir" : 2,
    "rlaiin" : 2,
    "loaiin" : 2,
    "yraiin" : 2,
]

/// dictionary with the groups with most similarities for each page
/// to calculate the values at runtime would need to much time since the calculation needs to much time for cal to boost perfomance
let compareMap: Dictionary<String, [String]> = [
    // Quire 1
    "f1r"  :  ["chol", "dain"],    // CURRIER A
    "f1v"  :  ["chol", "dal"],     // CURRIER A
    "f2r"  :  ["chy", "dan"],      // CURRIER A
    "f2v"  :  ["chor", "daiin"],   // CURRIER A
    "f3r"  :  ["chol", "dam"],     // CURRIER A
    "f3v"  :  ["chor", "okor"],    // CURRIER A
    "f4r"  :  ["chol", "daiin"],   // CURRIER A
    "f4v"  :  ["sho", "daiin"],    // CURRIER A
    "f5r"  :  ["chy", "qoaiin"],   // CURRIER A
    "f5v"  :  ["chol", "daiin"],   // CURRIER A
    "f6r"  :  ["chor", "daiin"],   // CURRIER A
    "f6v"  :  ["chor", "dy"],      // CURRIER A
    "f7r"  :  ["chol", "daiin"],   // CURRIER A
    "f7v"  :  ["dol", "daiin"],    // CURRIER A
    "f8r"  :  ["chol", "shey"],    // CURRIER A
    "f8v"  :  ["chol", "daiin"],   // CURRIER A
    // Quire 2
    "f9r"  :  ["cthy", "shor"],    // CURRIER A
    "f9v"  :  ["chor", "daiin"],   // CURRIER A
    "f10r" :  ["chor", "daiin"],   // CURRIER A
    "f10v" :  ["daiin", "chol"],   // CURRIER A
    "f11r" :  ["daiin", "chy"],    // CURRIER A
    "f11v" :  ["dy", "tchy"],      // CURRIER A
    "f13r" :  ["chol", "okchy"],   // CURRIER A
    "f13v" :  ["chy", "daiin"],    // CURRIER A
    "f14r" :  ["dy", "kchy"],      // CURRIER A
    "f14v" :  ["daiin", "chy"],    // CURRIER A
    "f15r" :  ["chy", "daiin"],    // CURRIER A
    "f15v" :  ["chor", "aiin"],    // CURRIER A
    "f16r" :  ["chy", "aiin"],     // CURRIER A
    "f16v" :  ["chor", "ykchy"],   // CURRIER A
    // Quire 3
    "f17r" :  ["chor", "dar"],     // CURRIER A
    "f17v" :  ["chol", "okeol"],   // CURRIER A
    "f18r" :  ["chor", "dar"],     // CURRIER A
    "f18v" :  ["qokchy", "or"],    // CURRIER A
    "f19r" :  ["chor", "daiin"],   // CURRIER A
    "f19v" :  ["daiin", "chor"],   // CURRIER A
    "f20r" :  ["cho", "otchey"],   // CURRIER A
    "f20v" :  ["cho", "daiin"],    // CURRIER A
    "f21r" :  ["chol", "shey"],    // CURRIER A
    "f21v" :  ["cho", "daiin"],    // CURRIER A
    "f22r" :  ["daiin", "chor"],   // CURRIER A
    "f22v" :  ["daiin", "tchy"],   // CURRIER A
    "f23r" :  ["dar", "chol"],     // CURRIER A
    "f23v" :  ["ol", "daiin"],     // CURRIER A
    "f24r" :  ["chor", "dal"],     // CURRIER A
    "f24v" :  ["sho", "otchol"],   // CURRIER A
    // Quire 4
    "f25r" :  ["chain", "daiin"],  // CURRIER A
    "f25v" :  ["daiin", "chor"],   // CURRIER A
    "f26r" :  ["qokedy", "aiin"],  // CURRIER B
    "f26v" :  ["ar", "chedy"],     // CURRIER B
    "f27r" :  ["chy", "dain"],     // CURRIER A
    "f27v" :  ["sho", "otchy"],    // CURRIER A
    "f28r" :  ["sho", "otchol"],   // CURRIER A
    "f28v" :  ["chor", "daiin"],   // CURRIER A
    "f29r" :  ["chor", "oty"],     // CURRIER A
    "f29v" :  ["cho", "daiin"],    // CURRIER A
    "f30r" :  ["chey", "dchor"],   // CURRIER A
    "f30v" :  ["daiin", "chor"],   // CURRIER A
    "f31r" :  ["qokedy", "aiin"],  // CURRIER B
    "f31v" :  ["ar", "okedy"],     // CURRIER B
    "f32r" :  ["daiin", "dol"],    // CURRIER A
    "f32v" :  ["daiin", "chol"],   // CURRIER A
    // Quire 5
    "f33r" :  ["aiin", "or"],      // CURRIER B
    "f33v" :  ["ar", "chdy"],      // CURRIER B
    "f34r" :  ["ar", "chey"],      // CURRIER B
    "f34v" :  ["chdy", "or"],      // CURRIER B
    "f35r" :  ["aiin", "chol"],    // CURRIER A
    "f35v" :  ["daiin", "chor"],   // CURRIER A
    "f36r" :  ["chy", "dain"],     // CURRIER A
    "f36v" :  ["daiin", "oky"],    // CURRIER A
    "f37r" :  ["daiin", "shor"],   // CURRIER A
    "f37v" :  ["daiin", "chor"],   // CURRIER A
    "f38r" :  ["daiin", "chy"],    // CURRIER A
    "f38v" :  ["daiin", "okeey"],  // CURRIER A
    "f39r" :  ["chedy", "dar"],    // CURRIER B
    "f39v" :  ["ar", "chdy"],      // CURRIER B
    "f40r" :  ["okar", "aiin"],    // CURRIER B
    "f40v" :  ["or", "chedy"],     // CURRIER B
    // Quire 6
    "f41r" :  ["qokedy", "chedy"], // CURRIER B
    "f41v" :  ["okey", "daiin"],   // CURRIER B
    "f42r" :  ["shol", "daiin"],   // CURRIER A
    "f42v" :  ["chol", "aiin"],    // CURRIER A
    "f43r" :  ["dar", "otedy"],    // CURRIER B
    "f43v" :  ["chedy", "otedy"],  // CURRIER B
    "f44r" :  ["qokchy", "chol"],  // CURRIER A
    "f44v" :  ["chol", "otol"],    // CURRIER A
    "f45r" :  ["dar", "cthy"],     // CURRIER A
    "f45v" :  ["dy", "chor"],      // CURRIER A
    "f46r" :  ["chdy", "daiin"],   // CURRIER B
    "f46v" :  ["chedy", "okedy"],  // CURRIER B
    "f47r" :  ["chol", "daiin"],   // CURRIER A
    "f47v" :  ["chy", "daiin"],    // CURRIER A
    "f48r" :  ["okedy", "ar"],     // CURRIER B
    "f48v" :  ["chedy", "otar"],   // CURRIER B
    // Quire 7
    "f49r" :  ["cho", "daiin"],    // CURRIER A
    "f49v" :  ["cho", "daiin"],    // CURRIER A
    "f50r" :  ["kar", "qokchdy"],  // CURRIER B
    "f50v" :  ["okar", "chedy"],   // CURRIER B
    "f51r" :  ["ckhey", "odaiin"], // CURRIER A
    "f51v" :  ["daiin", "qokol"],  // CURRIER A
    "f52r" :  ["oty", "dal"],      // CURRIER A
    "f52v" :  ["chor", "daiin"],   // CURRIER A
    "f53r" :  ["oty", "qokod"],    // CURRIER A
    "f53v" :  ["daiin", "chol"],   // CURRIER A
    "f54r" :  ["or", "ckhol"],     // CURRIER A
    "f54v" :  ["chol", "ar"],      // CURRIER A
    "f55r" :  ["okar", "aiin"],    // CURRIER B
    "f55v" :  ["aiin", "or"],      // CURRIER B
    "f56r" :  ["cho", "daiin"],    // CURRIER A
    "f56v" :  ["chol", "daiin"],   // CURRIER A
    // Quire 8
    "f57r" :  ["cheody", "sheey"], // CURRIER B
    "f57v" :  ["ar", "daiin"],     // CURRIER B
    "f58r" :  ["ar", "chol"],      // CURRIER A
    "f58v" :  ["okal", "dar"],     // CURRIER A
    "f65r" :  ["dam", ""],         // UNKNOWN
    "f65v" :  ["dy", "cheody"],    // UNKNOWN
    "f66r" :  ["ol", "shedy"],     // CURRIER B
    "f66v" :  ["dal", "cheody"],   // CURRIER B
    // Quire 9
    "f67r1" : ["ar", "daiin"],     // UNKNOWN
    "f67r2" : ["daiin", "ar"],     // UNKNOWN
    "f67v2" : ["or", "daim"],      // UNKNOWN
    "f67v1" : ["or", "cheo"],      // UNKNOWN
    "f68r1" : ["otor", "chteey"],  // UNKNOWN
    "f68r2" : ["oko", "cheor"],    // UNKNOWN
    "f68r3" : ["oteey", "dol"],    // UNKNOWN
    "f68v1" : ["shes", "okeey"],   // UNKNOWN
    "f68v2" : ["chey", "otey"],    // UNKNOWN
    "f68v3" : ["okol", "dar"],     // UNKNOWN
    // Quire 10
    "f69r"  : ["ar", "chy"],       // UNKNOWN
    "f69v"  : ["chy", "okeedy"],   // UNKNOWN
    "f70r1" : ["al", "oteos"],     // UNKNOWN
    "f70r2" : ["ar", "chol"],      // UNKNOWN
    "f70v2" : ["ar", "oty"],       // UNKNOWN
    "f70v1" : ["dal", "raiin"],    // UNKNOWN
    // Quire 11
    "f71r"  : ["al", "oto"],       // UNKNOWN
    "f71v"  : ["al", "oteey"],     // UNKNOWN
    "f72r1" : ["ar", "oaiin"],     // UNKNOWN
    "f72r2" : ["okal", "aiin"],    // UNKNOWN
    "f72r3" : ["ar", "oteey"],     // UNKNOWN
    "f72v3" : ["otey", "okaly"],   // UNKNOWN
    "f72v2" : ["ar", "okeody"],    // UNKNOWN
    "f72v1" : ["otey", "aiin"],    // UNKNOWN
    // Quire 12
    "f73r"  : ["ar", "oteos"],     // UNKNOWN
    "f73v"  : ["okeody", "oty"],   // UNKNOWN
    // Quire 13
    "f75r"  : ["shedy", "ol"],      // CURRIER B
    "f75v"  : ["ol", "chedy"],      // CURRIER B
    "f76r"  : ["chedy", "ol"],      // CURRIER B
    "f76v"  : ["chedy", "qokeedy"], // CURRIER B
    "f77r"  : ["qokeedy", "chedy"], // CURRIER B
    "f77v"  : ["chedy", "qokedy"],  // CURRIER B
    "f78r"  : ["okedy", "ol"],      // CURRIER B
    "f78v"  : ["ol", "shedy"],      // CURRIER B
    "f79r"  : ["ol", "shey"],       // CURRIER B
    "f79v"  : ["qokeedy", "ol"],    // CURRIER B
    "f80r"  : ["qokain", "ol"],     // CURRIER B
    "f80v"  : ["ol", "chedy"],      // CURRIER B
    "f81r"  : ["ol", "chedy"],      // CURRIER B
    "f81v"  : ["ol", "chedy"],      // CURRIER B
    "f82r"  : ["chedy", "qokeedy"], // CURRIER B
    "f82v"  : ["chedy", "qokal"],   // CURRIER B
    "f83r"  : ["chedy", "qokedy"],  // CURRIER B
    "f83v"  : ["shedy", "qokal"],   // CURRIER B
    "f84r"  : ["shedy", "qokedy"],  // CURRIER B
    "f84v"  : ["okedy", "shedy"],   // CURRIER B
    // Quire 14
    "f85r1" : ["chedy", "dar"],    // UNKNOWN
    "f85r2" : ["ar", "chedy"],     // UNKNOWN
    "f86v3" : ["aiin", "chedy"],   // UNKNOWN
    "f86v4" : ["ar", "otedy"],     // UNKNOWN
    "f86v5" : ["ar", "kaiin"],     // UNKNOWN
    "f86v6" : ["ar", "okaiin"],    // UNKNOWN
    // Quire 15
    "f87r"  : ["cheor", "sol"],    // CURRIER A
    "f87v"  : ["cthey", "al"],     // CURRIER A
    "f88r"  : ["cheol", "or"],     // CURRIER A
    "f88v"  : ["daiin", "cheor"],  // CURRIER A
    "f89r1" : ["dal", "daiin"],    // CURRIER A
    "f89r2" : ["daiin", "cheo"],   // CURRIER A
    "f89v1" : ["daiin", "dal"],    // CURRIER A
    "f89v2" : ["daiin", "dal"],    // CURRIER A
    "f90r1" : ["tor", "qokchod"],  // CURRIER A
    "f90r2" : ["cheo", "al"],      // CURRIER A
    "f90v1" : ["cheor", "sy"],     // CURRIER A
    "f90v2" : ["sheol", "chody"],  // CURRIER A
    // Quire 16 missing
    // Quire 17
    "f93r"  : ["chol", "dal"],     // CURRIER A
    "f93v"  : ["chol", "dar"],     // CURRIER A
    "f94r"  : ["okar", "chedy"],   // CURRIER B
    "f94v"  : ["ar", "oteey"],     // CURRIER B
    "f95r1" : ["chdy", "okaiin"],  // CURRIER B
    "f95r2" : ["okar", "shdy"],    // CURRIER B
    "f95v1" : ["chdy", "okain"],   // CURRIER B
    "f95v2" : ["aiin", "okar"],    // CURRIER B
    "f96r"  : ["or", "cheol"],     // CURRIER A
    "f96v"  : ["cheor", "sar"],    // CURRIER A
    // Quire 18 missing
    // Quire 19
    "f99r"  : ["okeey", "chol"],   // CURRIER A
    "f99v"  : ["okeol", "aiin"],   // CURRIER A
    "f100r" : ["chol", "daiin"],   // CURRIER A
    "f100v" : ["chol", "okeol"],   // CURRIER A
    "f101r1": ["or", "cheol"],     // CURRIER A
    "f101v2": ["or", "daiin"],     // CURRIER A
    "f102r1": ["qokeol", "dor"],   // CURRIER A
    "f102r2": ["dol", "chey"],     // CURRIER A
    "f102v1": ["cheo", "daiin"],   // CURRIER A
    "f102v2": ["or", "okeo"],      // CURRIER A
    // Quire 20
    "f103r" : ["qokeey", "shey"],  // CURRIER B
    "f103v" : ["shey", "okeey"],   // CURRIER B
    "f104r" : ["ar", "qokaiin"],   // CURRIER B
    "f104v" : ["chedy", "ar"],     // CURRIER B
    "f105r" : ["ar", "chedy"],     // CURRIER B
    "f105v" : ["aiin", "al"],      // CURRIER B
    "f106r" : ["aiin", "chedy"],   // CURRIER B
    "f106v" : ["chedy", "ar"],     // CURRIER B
    "f107r" : ["kaiin", "al"],     // CURRIER B
    "f107v" : ["okaiin", "okal"],  // CURRIER B
    "f108r" : ["qokedy", "chedy"], // CURRIER B
    "f108v" : ["qokeey", "chey"],  // CURRIER B
    "f111r" : ["qokeey", "chedy"], // CURRIER B
    "f111v" : ["okain", "chey"],   // CURRIER B
    "f112r" : ["okeey", "ar"],     // CURRIER B
    "f112v" : ["aiin", "qokeedy"], // CURRIER B
    "f113r" : ["aiin", "al"],      // CURRIER B
    "f113v" : ["ar", "okaiin"],    // CURRIER B
    "f114r" : ["aiin", "chedy"],   // CURRIER B
    "f114v" : ["oaiin", "chedy"],  // CURRIER B
    "f115r" : ["chey", "ar"],      // CURRIER B
    "f115v" : ["chedy", "or"],     // CURRIER B
    "f116r" : ["chey", "ain"],     // CURRIER B
]

class SimilarResults {
    
    /// determine the words with highest number of similarities
    class func determineCompareWords(pageName: String, groupArrays: [[String]]) -> (compareGroup1: String, compareGroup2: String) {
        var maxCount = 0
        var groupMap = Dictionary<String, Int>()
        var compareGroup1 = ""
        var compareGroup2 = ""
        
        // determine the word with the highest number of similarities
        for groupArray in groupArrays {
            for group in groupArray {
                let count = groupMap[group]
                if count == nil {
                    let tmpCount = SimilarResults.countSimilarWords(group, groupArrays: groupArrays)
                    groupMap[group] = tmpCount
                    if tmpCount > maxCount {
                        maxCount = tmpCount
                        compareGroup1 = group
                    }
                }
            }
        }
        
        // determine a distinct word with also many similarities
        maxCount = 0
        for group in groupMap.keys {
            let count = groupMap[group]
            if let c = count {
                if c > maxCount {
                    let distance = Levenshtein.getDistance(group, t: compareGroup1, damerau: true)
                    if distance > 3 {
                        maxCount = c
                        compareGroup2 = group
                    }
                }
            }
        }
        
        return (compareGroup1: compareGroup1, compareGroup2: compareGroup2)
    }
    
    /// calculate the number of similarities for a compare group
    class func countSimilarWords(compare: String, groupArrays: [[String]]) -> Int {
        
        var count = 0
        let length = compare.characters.count
        if length > 1 {
            for groupArray in groupArrays {
                for group in groupArray {
                    let distance = Levenshtein.getDistanceOptimized(group, t: compare)
                    switch distance {
                    case 0:
                        count += 7
                    case 1:
                        count += 5
                    case 2:
                        count += 2
                    default:
                        let s = 0
                        group.containsPos(compare)
                        if s >= 0 {
                            count++
                        }
                    }
                }
            }
        }
        
        return count
    }
    
    /// search for similar groups with editDistance <= 2 within the VMS
    class func calcDistances(compareGroup: String, voynichLoader: OriginalVonyichLoader) {
        
        let start = NSDate()
        var distanceMap = Dictionary<String, Int>()
        for pageName in voynichPages {
            let textLines: [String] = voynichLoader.getLinesForPage(pageName)
            for line in textLines {
                
                let textArray = line.componentsSeparatedByString(" ")
                for group in textArray {
                    var distance = -1
                    
                    let tmpDistance = distanceMap[group]
                    if let dist = tmpDistance {
                        distance = dist
                    } else {
                        distance = Levenshtein.getDistanceOptimized(group, t: compareGroup)
                        distanceMap.updateValue(distance, forKey: group)
                        if distance <= 2 {
                            //"shod"   : 2,
                            print("\"\(group)\" : \(distance),")
                        }
                    }
                }
            }
        }
        
        let elapsedTime = NSDate().timeIntervalSinceDate(start) // in Seconds
        print("elapsed time \(elapsedTime) sec")
    }
    
    /// search for the glyphGroups with the majority of the similarities
    class func calcTopWords(voynichLoader: OriginalVonyichLoader) {
        
        let start = NSDate()
        let startPage = "f1r"
        var doit = false
        for pageName in voynichPages {
            if doit {
                let textLines: [String] = voynichLoader.getLinesForPage(pageName)
                var groupArrays: [[String]] = [[String]]()
                for line in textLines {
                    let groupArray = line.componentsSeparatedByString(" ")
                    groupArrays.append(groupArray)
                }
                let result = SimilarResults.determineCompareWords(pageName, groupArrays: groupArrays)
                
                // "f2r"  :  ["chy", "dan"],
                print("\"\(pageName)\" : [\"\(result.compareGroup1)\", \"\(result.compareGroup2)\"],")
            } else if pageName == startPage {
                doit = true
            }
        }
        
        let elapsedTime = NSDate().timeIntervalSinceDate(start) // in Seconds
        print("elapsed time \(elapsedTime) sec")
    }
}
