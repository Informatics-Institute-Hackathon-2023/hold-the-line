# hold-the-line
Repository for "Hold the Line" project on central line infections

Infection of venous catheters are a significant problem in hospitals. 

Our goal is look at potential indicators and predictors of venous catheter infections.

## Investigation of Data

Our initial data survey was conducted in UAB's i2b2. We queried for a case cohort of patients with infected catheters and a control cohort of patients that had catheters, but had no infection. ICD-10 and CPT codes were determined, with guidance from Amy Wang, using the i2b2 concept browser and search features.
 * Query Terms 
    * Dx of infection: 
        * ICD-10: T80.21 - infection due to central venous catheter
	   * minus T80.212 - local infection - exclude that? not very impactful
    * Placement of venous catheter
        * Urinary Catheterization (NOT included)
	  * CPT Code 51701: Insertion of non-indwelling bladder catheter (e.g., straight catheterization for residual urine).
	  * CPT Code 51702: Insertion of indwelling bladder catheter (e.g., Foley catheter).
	* Central Venous Catheterization: (INCLUDED)
	  * CPT Code 36555: Insertion of non-tunneled centrally inserted central venous catheter (CVC).
	  * CPT Code 36556: Insertion of tunneled centrally inserted central venous catheter (CVC).
        *  Arterial Catheterization: (NOT included)
	  * CPT Code 36620: Insertion of arterial catheter for blood sampling or monitoring.
 * Observations of trends
     * total population of ~40k patients who had catheters placed. 
     * ~800 cases of catheter infection, with only ~200 cases of non-local infection.
     * we observed that African Americans seemed more highly represented in the infected group, relative to the total population.
        * population: ~35% African American, cases: ~42% African American
        * this lead us to speculate whether geographical or socioeconomic factors may be in play.

Based on these observations, we set out to look at the following patient facts for predicting infection: 
  * Basic level
    * Basic Demographcis: Age, Sex, Ethnicity
    * Socioeconomic: zip code/region
  * Advanced
    * location in hosptial (not available in i2b2, only PowerInsight with IRB?)
    * procedures
    * medications 
  * Asperational
    * MD and nurse treating (not available in i2b2, only PowerInsight with IRB?)

Ideally, we would like to look at these facts in a time-dependent way, but that is likely beyound the scope of this hackathon. 

HOWEVER, as last minute entry, we faced technical and logistical barriers to extracting a LDS dataset out of i2b2 over the weekend. 
We there for sought external datasets to use to prototype the analysis. 
  * PhysioNet
     * Again, starting at the last moment, we could only use public data sets, as we couldn't get our accounts credentialed over the wekend.
     * public
         * MIMIC-III-DEMO: https://physionet.org/content/mimiciii-demo/1.4/
            * N=100
            * this data set uses ICD-9 codes, and appears NOT to have any cases of catheter infection
                * [Explore-MIMIC-III-DEMO.ipynb](physionet/public/Explore-MIMIC-III-DEMO.ipynb)
                *  [Explore-MIMIC-III-DEMO.ipynb.pdf](physionet/public/Explore-MIMIC-III-DEMO.ipynb.pdf)
         * MIMIC-IV-DEMO: https://physionet.org/content/mimic-iv-demo/2.2/
            * N=100
            * this data set uses ICD-9 and ICD-10 codes, and appears to have 2 individuals with catheter infection
              * [Explore-MIMIC-IV-DEMO.ipynb](physionet/public/Explore-MIMIC-IV-DEMO.ipynb)
              * [Explore-MIMIC-IV-DEMO.ipynb.pdf](physionet/public/Explore-MIMIC-IV-DEMO.ipynb.pdf)
         * MIMIC-IV-DEMO-OMOP: https://physionet.org/content/mimic-iv-demo-omop/0.9
            * not investigated
     * Credentialed 
         * MIMIC-IV: https://physionet.org/content/mimiciv/2.2/

## Analysis
