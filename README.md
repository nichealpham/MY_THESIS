<h2>DEVELOPMENT OF AN EKG RISK SCORE SYSTEM APPLIED FOR DETECTION AND QUANTIFICATION OF 
MYOCARDIAL DAMAGE USING MORPHOLOGICAL FEATURES AND DE-TRENDED FLUCTUATION ANALYSIS</h2>

<h3>Contact Information</h3>
Name:  Phạm Khôi Nguyên<br/>
School:  International University – Vietnam National University (VNU)<br/>
Department:  Biomedical Engineering<br/>
Email: phamkhoinguyen1995@gmail.com<br/>

<h3>Abstract:</h3>
The algorithm proposed in this project strives to provide doctors with a remote diagnosis tool for Cardiovascular Diseases.<br/></br>
During the last decade we have witnessed the tremendous growth of Telecommunication technologies, particularly the advancement in the field of semiconductors, wireless network and cloud infrastructure that could eventually bring forward the era of homecare. As a result, these innovations have made early diagnosis and prevention medicine for Cardiovascular Disease (CD) feasible. In Vietnam, there is a constant interest in the development of various types of real - time, wireless EKG (ECG) devices dedicated to people who are at high risk of CD, where many startups emerged to provide this type of innovative products to the community. As appealing as it may sound, however, these devices are currently lack of a decent diagnosing system. Therefore, this project aims to develop an algorithm capable of analyzing EKG input to provide automatic diagnosis of Cardiovascular Disease. In future work, the algorithm will be integrated into an online platform dedicated for real – time diagnosis of CD.

<h3>Status:</h3>
Underdevelopment

<h3>Disclaimer:</h3>
<p>This project is part of my university research. Some of the algorithms developed in this respiratory will be published soon so you need to reference me or this respiratory if you find them usefull in your work.</p>
<b>IMPORTANT:</b> I am not owning the code in the following directory<br/>
1. lib: library codes from other sources that are applied in this research<br/>
2. ecg-kit-0.1.6: this folder and algorithms within it belongs to Marianux. FInd out more about him at: http://marianux.github.io/ecg-kit/<br/>

<h3>Directories description:</h3>
- database/euro: test data from European database.<br/>
https://physionet.org/physiobank/database/edb/<br/>
- ecg-kit-0.1.6: ECG wrapper code used in this thesis, written by Marianux.<br/>
http://marianux.github.io/ecg-kit/<br/>
- recordings: output data captured during algorithm design<br/>
- results: image captured from the outcome of the algorithm<br/>
- research\Prethesis\HK2: articles and documentation about this project<br/>
PRETHESIS REPORT.pdf, QUANTIFYING MYOCARDIAL DAMAGE USING ECG SIGNAL.pptx<br/>
- code files: Matlab .m files<br/>

<h3>Research methodologies:</h3>
<b>1. Signal preprocessing:</b><br/>
<p>+ Baseline wander removal and noise estimation using Discrete Wavelet Decomposition</p>
<b>2. EKG delineation:</b></p>
<p>+ Self constructed R peak and T peak detection:</p>
<p>+ https://www.mathworks.com/matlabcentral/fileexchange/submissions/61156-ecg-qrs-peak-and-t-peak-detection</p>
<p>+ ST segment detection</p>
<b>3. Features extraction:</b><br/>
<p>+ Window length of 10 seconds</p>
<p>+ ST deviation and ST slope calibration for each beat, then calculate mean value for the 10 second span</p>
<p>+ Applied Detrended FLuctuation Analysis to the beat to beat segment, then calculate mean value for the 10 second span</p>
<b>4. Thresholding:</b><br/>
<p>+ ST segment elevation Myocardial Infarction: ST deviation > 40 and ST slope > 6, with or without DFA higher than 1</p>
<p>+ ST segment depression Myocardial Infarction: ST deviation < -20 and ST slope < -4, with or without DFA higher than 1</p>
<p>+ Myocardial Ischemia: T wave inversion, with or without ST deviation < -20</p>
<p>+ Normal subject: ST deviation < 40 and > -20, ST slope < 6 and > -4, DFA < 1</p>
<b>5. Validation:</b><br/>
<p>+ Thresholds obtained is compared and adjusted according to American Heart Association (AHA) guideline for myocardial infarction</p>
<p>+ Still underdevelopment and validation...</p>

<b>6. Implementation:</b><br/>
<p>+ Real time application web service will locate at: http://www.cassandra.com.vn/</p>
<p>+ Cross platform application development: Android, iOS</p>
<p>+ Desktop application: Matlab runtime</p>

<h3>Author:</h3>
Phạm Khôi Nguyên<br/>
phamkhoinguyen1995@gmail.com
