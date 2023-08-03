This directory contains raw and cleaned data from IRS statistics of income (SOI).

** raw data **

The "IRS raw data" folder contains the raw data.

For years since 1993, Table 1.4 from the link below provides the spreadsheets:
https://www.irs.gov/statistics/soi-tax-stats-individual-income-tax-returns-complete-report-publication-1304-basic-tables-part-1

For years 1954-1992, the link below provides the PDFs of SOI:
https://www.irs.gov/statistics/soi-tax-stats-archive-1954-to-1999-individual-income-tax-return-reports

For years 1934-1953, the link below provides the PDFs of SOI:
https://www.irs.gov/statistics/soi-tax-stats-archive-1934-to-1953-statistics-of-income-report-part-1

For years 1916-1933, the link below provides the PDFs of SOI:
https://www.irs.gov/statistics/soi-tax-stats-archive-1916-to-1933-statistics-of-income-reports

The spreadsheets since 1993 are directly downloaded from IRS.

The spreadsheets before 1993 were manually created by coauthors, checking accuracy by comparing total numbers computed by adding up rows and the numbers copied from the SOI PDF.

** cleaned data **

Here are the instructions to obtain the cleaned data:

1. Go to "IRS cleaned data" folder, open Matlab, set path to "IRS raw data" folder, and run "clean_IRS_data.m"; this will save results as IRSYYYY.xlsx, where YYYY is year.

2. Currently the Matlab file is written to deal with 1916-2019 data. If new data are released, we need to add a few lines to the code.
