
# Sex-Chromosome Dosage Analysis in the California Sea Lion (*Zalophus californianus*)

### Cell and Molecular Biology | Individual Practical Exercise

**Student Name:** Ijan, Shane Mae B.  
**Student ID:** 202400735  
**Section:** A  

---

## Project Overview

This project investigates sex-chromosome dosage in the California sea lion (*Zalophus californianus*) using whole-genome sequencing (WGS) data and a chromosome-level reference genome. The analysis was conducted using the Galaxy platform for sequence quality assessment, read alignment, and chromosome coverage estimation, followed by R for data processing, visualization, and sex-chromosome dosage interpretation.

The primary objective of this exercise is to calculate the X-to-autosome (X:A) sequencing-depth ratio and use it to infer the sex-chromosome complement of the WGS donor. The inferred result is then compared with the sex information recorded in the NCBI BioSample metadata.

## Introduction

Sex determination in mammals generally follows an XX/XY chromosomal system, in which females typically possess two X chromosomes (XX), while males possess one X and one Y chromosome (XY). Because autosomes are ordinarily present in two copies in diploid individuals, differences in sequencing coverage between sex chromosomes and autosomes can provide evidence of sex-chromosome dosage.

In an XX individual, the expected X-to-autosome (X:A) sequencing-depth ratio is approximately 1.0, whereas an XY individual typically has a ratio near 0.5. These expected values provide a basis for interpreting whole-genome sequencing data, although technical and biological factors may influence the observed ratios.

This study focuses on the California sea lion (*Zalophus californianus*), a marine mammal belonging to the family Otariidae. As a placental mammal, it follows the XX/XY sex-determination system. Its chromosome-level reference genome contains annotated autosomes and X and Y chromosomes, making it suitable for chromosome dosage analysis.

By combining whole-genome sequencing data, chromosome coverage estimates, and computational analysis, this exercise demonstrates how sequencing depth can be used to investigate sex-chromosome complement while considering the limitations of reference-based analysis.

## Reference Genome and Sequencing Data

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

---


## Materials and Methods

### Reference Genome and WGS Data Acquisition

The chromosome-level reference genome of the California sea lion (*Zalophus californianus*) was obtained from NCBI using assembly accession `GCF_009762305.2` (`mZalCal1.pri.v2`). Whole-genome sequencing (WGS) reads were retrieved from NCBI SRA under accession `SRR25744544` (BioSample `SAMN12368149`), generated using an Illumina NovaSeq 6000 platform with paired-end 151-bp reads.

The reference FASTA and paired-end FASTQ datasets were imported into Galaxy (https://usegalaxy.org/) using the reference upload and `fastq-dump` tools, respectively. The datasets were organized in the Galaxy history `Sex_Dosage_Zalophus_californianus`.

![Galaxy reference genome and paired-end sequencing inputs](screenshots/01_galaxy_input_data.png)

**Figure 1.** Reference genome and paired-end WGS datasets imported into Galaxy.

### Sequence Quality Assessment Using FastQC

Sequence quality was assessed using **FastQC** in Galaxy. The reports were examined for per-base sequence quality, GC content, sequence length distribution, and other quality indicators before proceeding to alignment.

![FastQC quality assessment](screenshots/02_fastqc_report.png)

**Figure 2.** FastQC quality-control report for the paired-end sequencing reads.

### Read Alignment Using BWA-MEM

Paired-end WGS reads were aligned against the reference genome using **BWA-MEM** in Galaxy. The resulting BAM alignment dataset was used for chromosome-level coverage estimation.

![BWA-MEM alignment output](screenshots/03_bwa_mem_alignment.png)

**Figure 3.** BWA-MEM alignment and resulting BAM dataset in Galaxy.

### Chromosome-Level Coverage Estimation Using Samtools

Chromosome-level sequencing depth was calculated from the BAM dataset using **Samtools coverage** in Galaxy. A minimum mapping quality (MAPQ) of **20** and minimum base quality of **20** were applied. Unmapped, duplicate, secondary, and quality-control-failed reads were excluded.

The output contained 47 reference-sequence entries, including mean sequencing depth and other coverage statistics, and was downloaded as `data/chromosome_coverage.tsv`.

![Samtools coverage parameters](screenshots/04_samtools_parameters.png)

**Figure 4.** Samtools coverage settings used to estimate chromosome-level sequencing depth.

### Chromosome Identification and Classification

Chromosomes were identified using NCBI reference annotations and sequence accession names from the Samtools coverage output.

| Chromosome group | Reference accessions |
|---|---|
| 17 autosomes | `NC_045595.1` to `NC_045611.1` |
| X chromosome | `NC_045612.1` |
| Y chromosome | `NC_045613.1` |

Mitochondrial DNA (`NC_008416.1`) and unplaced scaffolds (`NW_` accessions) were excluded. Chromosome labels were recorded in `data/chromosome_groups.csv` using the groups `A`, `X`, and `Y`.

![Chromosome classification](screenshots/05_chromosome_classification.png)

**Figure 5.** Classification of autosomal and sex-chromosome reference sequences.

### Chromosome Dosage Analysis Using RStudio

Chromosome coverage was analyzed in **RStudio** using `sex_depth_analysis.R`. The script combined `chromosome_coverage.tsv` and `chromosome_groups.csv`, calculated the median mean depth across 17 autosomes, and normalized each chromosome's mean depth against this value.

**Relative depth = Chromosome mean depth / Median autosomal depth**

The script generated:

- `results/chromosome_relative_depth.csv` — normalized chromosome coverage
- `results/chromosome_depth.png` — relative-depth bar plot
- `results/sex_inference.txt` — calculated ratios and sex inference

![RStudio chromosome dosage analysis](screenshots/06_rstudio_analysis.png)

**Figure 6.** Chromosome dosage analysis performed in RStudio.

### Sex-Chromosome Complement Interpretation and Validation

The X-to-autosome (X:A) ratio was interpreted using the expected values for a diploid XX/XY system: approximately **1.0 for XX** and **0.5 for XY**. These values were treated as classroom guidelines rather than definitive diagnostic thresholds.

The inferred complement was compared with the recorded sex of NCBI BioSample `SAMN12368149`, shared by the reference assembly and WGS dataset. Potential effects of repetitive regions, mapping bias, pseudoautosomal sequences, and incomplete sex-chromosome assemblies were considered when interpreting the results.

The final inference was based on sequencing-depth evidence rather than chromosome lengths or the reference assembly alone.

---


## Results

### Chromosome-Level Relative Sequencing Depth

The R analysis successfully processed the sequencing coverage data for *17 autosomes, the X chromosome, and the Y chromosome*. The normalized coverage values were saved in `results/chromosome_relative_depth.csv`.

The median autosomal sequencing depth was *16.096×*, which served as the normalization baseline. Most autosomal chromosomes showed relative sequencing depths close to 1.0, while the X chromosome had a lower relative depth of approximately 0.528.

The Y chromosome exhibited an unusually high relative depth of approximately 2.577.

### Visualization of Chromosome Coverage

The relative sequencing depths were visualized using a bar graph generated in RStudio.

![Relative chromosome sequencing depth in Zalophus californianus](results/chromosome_depth.png)

**Figure 7.** Relative sequencing depth of 17 autosomes and the X and Y chromosomes in Zalophus californianus. Autosomal depths cluster around 1.0, while the X chromosome has a relative depth near 0.5. The Y chromosome exhibits elevated coverage. Dashed reference lines indicate relative depths of 0.5 and 1.0.

The graph shows that the X chromosome has approximately half the sequencing depth of the autosomes, consistent with the expected pattern for an XY individual. However, the elevated Y chromosome coverage suggests possible effects of repetitive sequences, read-mapping bias, or limitations in the reference assembly.

### Sex-Chromosome Dosage Inference

The R script generated `results/sex_inference.txt`, which summarized the calculated chromosome-depth ratios and inferred sex-chromosome complement.

| Measurement | Result |
|---|---|
| Median autosomal depth | 16.096× |
| X chromosome mean depth | 8.49552× |
| Y chromosome mean depth | 41.4722× |
| X:A ratio | **0.528** |
| Y:A ratio | **2.577** |
| Inferred complement | **XY-like** |

The X-to-autosome (X:A) ratio was calculated as:

**X:A = 8.49552 / 16.096 ≈ 0.528**

This ratio is close to the expected value of 0.5 for an XY individual, supporting an *XY-like sex-chromosome complement* in the California sea lion WGS donor.

Although the Y:A ratio was unusually high, it was not treated as independent confirmation of sex because Y chromosome coverage may be distorted by repetitive regions and reference-mapping artifacts.

### Summary of R Analysis Outputs

The R analysis generated three files that collectively support the chromosome dosage interpretation.

| Output file | Purpose |
|---|---|
| [`chromosome_relative_depth.csv`](results/chromosome_relative_depth.csv) | Contains chromosome identities, mean depths, and normalized relative depths |
| [`chromosome_depth.png`](results/chromosome_depth.png) | Visualizes chromosome coverage relative to the median autosomal depth |
| [`sex_inference.txt`](results/sex_inference.txt) | Reports the median autosomal depth, X:A and Y:A ratios, and XY-like interpretation |

The three outputs consistently indicate reduced X-chromosome coverage relative to the autosomes, supporting an XY-like chromosome complement. The unusually elevated Y-chromosome depth remains an important limitation requiring cautious interpretation.



