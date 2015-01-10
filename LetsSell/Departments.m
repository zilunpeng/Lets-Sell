//
//  Departments.m
//  test
//
//  Created by Zilun Peng  on 2015-01-04.
//  Copyright (c) 2015 Zilun Peng . All rights reserved.
//

#import "Departments.h"

@implementation Departments

+(NSArray *) getAllDepartments
{
    NSArray *departments = [NSArray arrayWithObjects:
                            @"AANB",
                            @"ADHE",
                            @"AFST",
                            @"AGEC",
                            @"ANAE",
                            @"ANAT",
                            @"ANSC",
                            @"ANTH",
                            @"APBI",
                            @"APSC",
                            @"ARBC",
                            @"ARC",
                            @"ARCH",
                            @"ARCL",
                            @"ARST",
                            @"ARTH",
                            @"ARTS",
                            @"ASIA",
                            @"ASIC",
                            @"ASLA",
                            @"ASTR",
                            @"ASTU",
                            @"ATSC",
                            @"AUDI",
                            @"BA",
                            @"BAAC",
                            @"BABS",
                            @"BAEN",
                            @"BAFI",
                            @"BAHC",
                            @"BAHR",
                            @"BAIM",
                            @"BAIT",
                            @"BALA",
                            @"BAMA",
                            @"BAMS",
                            @"BAPA",
                            @"BASC",
                            @"BASD",
                            @"BASM",
                            @"BATL",
                            @"BATM",
                            @"BAUL",
                            @"BIOC",
                            @"BIOF",
                            @"BIOL",
                            @"BIOT",
                            @"BMEG",
                            @"BOTA",
                            @"BRDG",
                            @"BUSI",
                            @"CAPS",
                            @"CCFI",
                            @"CCST",
                            @"CDST",
                            @"CEEN",
                            @"CELL",
                            @"CENS",
                            @"CHBE",
                            @"CHEM",
                            @"CHIL",
                            @"CHIN",
                            @"CICS",
                            @"CIVL",
                            @"CLCH",
                            @"CLST",
                            @"CNPS",
                            @"CNRS",
                            @"CNTO",
                            @"COGS",
                            @"COHR",
                            @"COMM",
                            @"CONS",
                            @"CPSC",
                            @"CRWR",
                            @"CSIS",
                            @"CSPW",
                            @"DANI",
                            @"DENT",
                            @"DERM",
                            @"DHYG",
                            @"DMED",
                            @"DPAS",
                            @"ECED",
                            @"ECON",
                            @"EDCP",
                            @"EDST",
                            @"EDUC",
                            @"EECE",
                            @"ELI",
                            @"EMBA",
                            @"EMER",
                            @"ENDS",
                            @"ENGL",
                            @"ENPH",
                            @"ENPP",
                            @"ENVR",
                            @"EOSC",
                            @"EPSE",
                            @"ETEC",
                            @"EXCH",
                            @"EXGR",
                            @"FACT",
                            @"FEBC",
                            @"FHIS",
                            @"FIPR",
                            @"FISH",
                            @"FIST",
                            @"FMED",
                            @"FMPR",
                            @"FMST",
                            @"FNH",
                            @"FNLG",
                            @"FNSP",
                            @"FOOD",
                            @"FOPR",
                            @"FRE",
                            @"FREN",
                            @"FRSI",
                            @"FRST",
                            @"GENE",
                            @"GEOB",
                            @"GEOG",
                            @"GERM",
                            @"GREK",
                            @"GRS",
                            @"GRSJ",
                            @"GSAT",
                            @"HEBR",
                            @"HESO",
                            @"HGSE",
                            @"HINU",
                            @"HIST",
                            @"HUNU",
                            @"IAR",
                            @"IEST",
                            @"IGEN",
                            @"IHHS",
                            @"INDE",
                            @"INDO",
                            @"INDS",
                            @"INFO",
                            @"ISCI",
                            @"ITAL",
                            @"ITST",
                            @"JAPN",
                            @"JRNL",
                            @"KIN",
                            @"KORN",
                            @"LARC",
                            @"LASO",
                            @"LAST",
                            @"LATN",
                            @"LAW",
                            @"LFS",
                            @"LIBE",
                            @"LIBR",
                            @"LING",
                            @"LLED",
                            @"MATH",
                            @"MDVL",
                            @"MECH",
                            @"MEDG",
                            @"MEDI",
                            @"MICB",
                            @"MIDW",
                            @"MINE",
                            @"MRNE",
                            @"MTRL",
                            @"MUSC",
                            @"NAME",
                            @"NEST",
                            @"NEUR",
                            @"NRSC",
                            @"NURS",
                            @"OBMS",
                            @"OBST",
                            @"OHS",
                            @"ONCO",
                            @"OPTH",
                            @"ORNT",
                            @"ORPA",
                            @"PAED",
                            @"PATH",
                            @"PCTH",
                            @"PERS",
                            @"PHAR",
                            @"PHIL",
                            @"PHTH",
                            @"PHYL",
                            @"PHYS",
                            @"PLAN",
                            @"PLAS *",
                            @"PLNT",
                            @"POLI",
                            @"POLS",
                            @"PORT",
                            @"PRIN",
                            @"PSYC",
                            @"PSYT",
                            @"PUNJ",
                            @"RADI",
                            @"RELG",
                            @"RGLA",
                            @"RHSC",
                            @"RMES",
                            @"RMST",
                            @"RSOT",
                            @"RUSS",
                            @"SANS",
                            @"SCAN",
                            @"SCIE",
                            @"SEAL",
                            @"SLAV",
                            @"SOAL",
                            @"SOCI",
                            @"SOIL",
                            @"SOWK",
                            @"SPAN",
                            @"SPHA",
                            @"SPPH",
                            @"STAT",
                            @"STS",
                            @"SURG",
                            @"SWED",
                            @"TEST",
                            @"THTR",
                            @"TIBT",
                            @"TRSC",
                            @"UDES",
                            @"UKRN",
                            @"URO",
                            @"UROL*",
                            @"URST",
                            @"VANT",
                            @"VGRD",
                            @"VISA",
                            @"VRHC",
                            @"VURS",
                            @"WOOD",
                            @"WRDS",
                            @"WRIT",
                            @"ZOOL", nil];
    return departments;
}

@end