
# Sex-Chromosome Dosage Analysis in the California Sea Lion (*Zalophus californianus*)

### Cell and Molecular Biology | Individual Practical Exercise

**Student Name:** Ijan, Shane Mae B.  
**Student ID:** 202400735  
**Section:** A  

---

## Project Overview

This project investigates sex-chromosome dosage in the California sea lion (*Zalophus californianus*) using whole-genome sequencing (WGS) data and a chromosome-level reference genome. The analysis was conducted using the Galaxy platform for sequence quality assessment, read alignment, and chromosome coverage estimation, followed by R for data processing, visualization, and sex-chromosome dosage interpretation.

The primary objective of this exercise is to calculate the X-to-autosome (X:A) sequencing-depth ratio and use it to infer the sex-chromosome complement of the WGS donor. The inferred result is then compared with the sex information recorded in the NCBI BioSample metadata.

## 1. Introduction

Sex determination in mammals generally follows an XX/XY chromosomal system, in which females typically possess two X chromosomes (XX), while males possess one X and one Y chromosome (XY). Because autosomes are ordinarily present in two copies in diploid individuals, differences in sequencing coverage between sex chromosomes and autosomes can provide evidence of sex-chromosome dosage.

In an XX individual, the expected X-to-autosome (X:A) sequencing-depth ratio is approximately 1.0, whereas an XY individual typically has a ratio near 0.5. These expected values provide a basis for interpreting whole-genome sequencing data, although technical and biological factors may influence the observed ratios.

This study focuses on the California sea lion (*Zalophus californianus*), a marine mammal belonging to the family Otariidae. As a placental mammal, it follows the XX/XY sex-determination system. Its chromosome-level reference genome contains annotated autosomes and X and Y chromosomes, making it suitable for chromosome dosage analysis.

By combining whole-genome sequencing data, chromosome coverage estimates, and computational analysis, this exercise demonstrates how sequencing depth can be used to investigate sex-chromosome complement while considering the limitations of reference-based analysis.

## 2. Reference Genome and Sequencing Data

| Information | Accession or Description |
|---|---|
| Species | *Zalophus californianus* |
| Common name | California sea lion |
| Reference assembly | GCF_009762305.2 |
| Assembly name | mZalCal1.pri.v2 |
| Assembly BioSample | SAMN12368149 |
| WGS run | SRR25744544 |
| WGS BioSample | SAMN12368149 |
| Sequencing platform | Illumina NovaSeq 6000 |
| Sequencing layout | Paired-end |

The reference genome assembly and WGS dataset are associated with the same BioSample accession (`SAMN12368149`), indicating that they originate from the same recorded biological donor. This allows the inferred sex-chromosome complement to be compared with the donor's reported sex in the NCBI metadata.

### Data Sources

- [NCBI Reference Genome Assembly](https://www.ncbi.nlm.nih.gov/assembly/GCF_009762305.2)
- [NCBI WGS Run](https://www.ncbi.nlm.nih.gov/sra/?term=SRR25744544)
- [NCBI BioSample](https://www.ncbi.nlm.nih.gov/biosample/SAMN12368149)
- [Galaxy Platform](https://usegalaxy.org/)
