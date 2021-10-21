List<String> allPlaces = [
  "Ahrweiler",
  "Aichach-Friedberg",
  "Alb-Donau-Kreis",
  "Altenburger Land",
  "Altenkirchen (Westerwald)",
  "Altmarkkreis Salzwedel",
  "Altötting",
  "Alzey-Worms",
  "Amberg",
  "Amberg-Sulzbach",
  "Ammerland",
  "Anhalt-Bitterfeld",
  "Ansbach",
  "Ansbach",
  "Aschaffenburg",
  "Aschaffenburg",
  "Augsburg",
  "Augsburg",
  "Aurich",
  "Bad Dürkheim",
  "Bad Kissingen",
  "Bad Kreuznach",
  "Bad Tölz-Wolfratshausen",
  "Baden-Baden",
  "Bamberg",
  "Bamberg",
  "Barnim",
  "Bautzen",
  "Bayreuth",
  "Bayreuth",
  "Berchtesgadener Land",
  "Kreis Bergstraße",
  "Berlin",
  "Bernkastel-Wittlich",
  "Biberach",
  "Bielefeld",
  "Birkenfeld",
  "Bochum",
  "Bodenseekreis",
  "Bonn",
  "Kreis Borken",
  "Bottrop",
  "Brandenburg an der Havel",
  "Braunschweig",
  "Breisgau-Hochschwarzwald",
  "Bremen",
  "Bremerhaven",
  "Burgen",
  "Böblingen",
  "Börde",
  "Calw",
  "Celle",
  "Cham",
  "Chemnitz",
  "Cloppenburg",
  "Coburg",
  "Coburg",
  "Cochem-Zell",
  "Kreis Coesfeld",
  "Cottbus",
  "Cuxhaven",
  "Dachau",
  "Dahme-Spreewald",
  "Darmstadt",
  "Darmstadt-Dieburg",
  "Deggendorf",
  "Delmenhorst",
  "Dessau-Roßlau",
  "Diepholz",
  "Dillingen an der Donau",
  "Dingolfing-Landau",
  "Kreis Dithmarschen",
  "Donau-Ries",
  "Donnersbergkreis",
  "Dortmund",
  "Dresden",
  "Duisburg",
  "Kreis Düren",
  "Düsseldorf",
  "Ebersberg",
  "Eichsfeld",
  "Eichstätt",
  "Eifelkreis",
  "Eisenach",
  "Elbe-Elster",
  "Emden",
  "Emmendingen",
  "Emsland",
  "Ennepe-Ruhr-Kreis",
  "Enzkreis",
  "Erding",
  "Erfurt",
  "Erlangen",
  "Erlangen-Höchstadt",
  "Erzgebirgskreis",
  "Essen",
  "Esslingen",
  "Kreis Euskirchen",
  "Flensburg",
  "Forchheim",
  "Frankenthal (Pfalz)",
  "Frankfurt (Oder)",
  "Frankfurt am Main",
  "Freiburg im Breisgau",
  "Freising",
  "Freudenstadt",
  "Freyung-Grafenau",
  "Friesland",
  "Fulda",
  "Fürstenfeldbruck",
  "Fürth",
  "Fürth",
  "Garmisch-Partenkirchen",
  "Gelsenkirchen",
  "Gera",
  "Germersheim",
  "Gießen",
  "Gifhorn",
  "Goslar",
  "Gotha",
  "Grafschaft Bentheim",
  "Greiz",
  "Kreis Groß-Gerau",
  "Göppingen",
  "Görlitz",
  "Göttingen",
  "Günzburg",
  "Kreis Gütersloh",
  "Hagen",
  "Halle (Saale)",
  "Hamburg",
  "Hameln-Pyrmont",
  "Hamm",
  "Harburg",
  "Harz",
  "Havelland",
  "Haßberge",
  "Heidekreis",
  "Heidelberg",
  "Heidenheim",
  "Heilbronn",
  "Heilbronn",
  "Kreis Heinsberg",
  "Helmstedt",
  "Kreis Herford",
  "Herne",
  "Hersfeld-Rotenburg",
  "Kreis Herzogtum Lauenburg",
  "Hildburghausen",
  "Hildesheim",
  "Hochsauer",
  "Hochtaunuskreis",
  "Hof",
  "Hohenlohekreis",
  "Holzminden",
  "Kreis Höxter",
  "Ilm-Kreis",
  "Ingolstadt",
  "Jena",
  "Jerichower Land",
  "Kaiserslautern",
  "Kaiserslautern",
  "Karlsruhe",
  "Kassel",
  "Kaufbeuren",
  "Kelheim",
  "Kempten (Allgäu)",
  "Kiel",
  "Kitzingen",
  "Kreis Kleve",
  "Koblenz",
  "Konstanz",
  "Krefeld",
  "Kronach",
  "Kulmbach",
  "Kusel",
  "Kyffhäuserkreis",
  "Köln",
  "Lahn-Dill-Kreis",
  "Landau in der Pfalz",
  "Landsberg am Lech",
  "Landshut",
  "Leer",
  "Leipzig",
  "Leverkusen",
  "Lichtenfels",
  "Limburg-Weilburg",
  "Lindau (Bodensee)",
  "Kreis Lippe",
  "Kreis Ludwigsburg",
  "Ludwigshafen am Rhein",
  "Ludwigslust-Parchim",
  "Lörrach",
  "Lübeck",
  "Lüchow-Dannenberg",
  "Lüneburg",
  "Magdeburg",
  "Main-Kinzig-Kreis",
  "Main-Spessart",
  "Main-Tauber-Kreis",
  "Main-Taunus-Kreis",
  "Mainz",
  "Mainz-Bingen",
  "Mannheim",
  "Mansfeld-Südharz",
  "Marburg-Biedenkopf",
  "Mayen-Koblenz",
  "Mecklenburgische Seenplatte",
  "Meißen",
  "Memmingen",
  "Merzig-Wadern",
  "Kreis Mettmann",
  "Miesbach",
  "Miltenberg",
  "Kreis Minden-Lübbecke",
  "Mittelsachsen",
  "Märkisch-Oderland",
  "Märkischer Kreis",
  "Mönchengladbach",
  "Mühldorf am Inn",
  "Mülheim an der Ruhr",
  "München",
  "Münster",
  "Neckar-Odenwald-Kreis",
  "Neu-Ulm",
  "Neuburg-Schrobenhausen",
  "Neumarkt in der Oberpfalz",
  "Neumünster",
  "Neunkirchen",
  "Neustadt an der Aisch-Bad Windsheim",
  "Neustadt an der Waldnaab",
  "Neustadt an der Weinstraße",
  "Neuwied",
  "Nienburg/Weser",
  "Kreis Nordfriesland",
  "Nordhausen",
  "Nordsachsen",
  "Nordwestmecklenburg",
  "Northeim",
  "Nürnberg",
  "Nürnberger Land",
  "Oberallgäu",
  "Oberbergischer Kreis",
  "Oberhausen",
  "Oberhavel",
  "Oberspreewald-Lausitz",
  "Odenwaldkreis",
  "Oder-Spree",
  "Offenbach",
  "Offenbach am Main",
  "Oldenburg",
  "Oldenburg (Oldb)",
  "Kreis Olpe",
  "Ortenaukreis",
  "Osnabrück",
  "Ostalbkreis",
  "Ostallgäu",
  "Osterholz",
  "Osterode am Harz",
  "Kreis Ostholstein",
  "Ostprignitz-Ruppin",
  "Kreis Paderborn",
  "Passau",
  "Peine",
  "Pfaffenhofen an der Ilm",
  "Pforzheim",
  "Kreis Pinneberg",
  "Pirmasens",
  "Kreis Plön",
  "Potsdam",
  "Potsdam-Mittelmark",
  "Prignitz",
  "Rastatt",
  "Ravensburg",
  "Kreis Recklinghausen",
  "Regen",
  "Regensburg",
  "Region Hannover",
  "Regionalverband Saarbrücken",
  "Rems-Murr-Kreis",
  "Remscheid",
  "Kreis Rendsburg-Eckernförde",
  "Reutlingen",
  "Rhein-Erft-Kreis",
  "Rhein-Hunsrück-Kreis",
  "Rhein-Kreis Neuss",
  "Rhein-Lahn-Kreis",
  "Rhein-Neckar-Kreis",
  "Rhein-Pfalz-Kreis",
  "Rhein-Sieg-Kreis",
  "Rheingau-Taunus-Kreis",
  "Rheinisch-Bergischer Kreis",
  "Rhön-Grabfeld",
  "Rosenheim",
  "Rostock",
  "Rotenburg (Wümme)",
  "Roth",
  "Rottal-Inn",
  "Rottweil",
  "Saale-Holzland-Kreis",
  "Saale-Orla-Kreis",
  "Saalekreis",
  "Saalfeld-Rudolstadt",
  "Saarlouis",
  "Saarpfalz-Kreis",
  "Salzgitter",
  "Salz",
  "Schaumburg",
  "Kreis Schleswig-Flensburg",
  "Schmalkalden-Meiningen",
  "Schwabach",
  "Schwalm-Eder-Kreis",
  "Schwandorf",
  "Schwarzwald-Baar-Kreis",
  "Schweinfurt",
  "Schwerin",
  "Schwäbisch Hall",
  "Kreis Segeberg",
  "Kreis Siegen-Wittgenstein",
  "Sigmaringen",
  "Kreis Soest",
  "Solingen",
  "Sonneberg",
  "Speyer",
  "Spree-Neiße",
  "St. Wendel",
  "Stade",
  "Starnberg",
  "Kreis Steinburg",
  "Kreis Steinfurt",
  "Stendal",
  "Kreis Stormarn",
  "Straubing",
  "Straubing-Bogen",
  "Stuttgart",
  "Städteregion Aachen",
  "Suhl",
  "Sächsische Schweiz-Osterzgebirge",
  "Sömmerda",
  "Südliche Weinstraße",
  "Südwestpfalz",
  "Teltow-Fläming",
  "Tirschenreuth",
  "Traunstein",
  "Trier",
  "Trier-Saarburg",
  "Tuttlingen",
  "Tübingen",
  "Uckermark",
  "Uelzen",
  "Ulm",
  "Kreis Unna",
  "Unstrut-Hainich-Kreis",
  "Unterallgäu",
  "Vechta",
  "Verden",
  "Kreis Viersen",
  "Vogelsbergkreis",
  "Vogt",
  "Vorpommern-Greifswald",
  "Vorpommern-Rügen",
  "Vulkaneifel",
  "Waldeck-Frankenberg",
  "Waldshut",
  "Kreis Warendorf",
  "Wartburgkreis",
  "Weiden in der Oberpfalz",
  "Weilheim-Schongau",
  "Weimar",
  "Weimarer Land",
  "Weißenburg-Gunzenhausen",
  "Werra-Meißner-Kreis",
  "Kreis Wesel",
  "Wesermarsch",
  "Westerwaldkreis",
  "Wetteraukreis",
  "Wiesbaden",
  "Wilhelmshaven",
  "Wittenberg",
  "Wittmund",
  "Wolfenbüttel",
  "Wolfsburg",
  "Worms",
  "Wunsiedel im Fichtelgebirge",
  "Wuppertal",
  "Würzburg",
  "Zollernalbkreis",
  "Zweibrücken",
  "Zwicka",
];
