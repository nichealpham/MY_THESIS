<b>DEVELOPMENT OF AN ECG SCORING SYSTEM APPLIED FOR DETECTION AND QUANTIFICATION OF 
MYOCARDIAL DAMAGE USING MORPHOLOGICAL FEATURES AND DE-TRENDED FLUCTUATION ANALYSIS</b>

<b>Contact Information</b><br/>
Name:  Phạm Khôi Nguyên<br/>
School:  International University – Vietnam National University (VNU)<br/>
Department:  Biomedical Engineering<br/>
Email: phamkhoinguyen1995@gmail.com<br/>

<b>Abstract:</b><br/>
The algorithm proposed in this project strives to provide doctors with a remote diagnosis tool for Cardiovascular Diseases.<br/></br>
During the last decade we have witnessed the tremendous growth of Telecommunication technologies, particularly the advancement in the field of semiconductors, wireless network and cloud infrastructure that could eventually bring forward the era of homecare. As a result, these innovations have made early diagnosis and prevention medicine for Cardiovascular Disease (CD) feasible. In Vietnam, there is a constant interest in the development of various types of real - time, wireless EKG (ECG) devices dedicated to people who are at high risk of CD, where many startups emerged to provide this type of innovative products to the community. As appealing as it may sound, however, these devices are currently lack of a decent diagnosing system. Therefore, this project aims to develop an algorithm capable of analyzing EKG input to provide automatic diagnosis of Cardiovascular Disease. In future work, the algorithm will be integrated into an online platform dedicated for real – time diagnosis of CD.

<b>Status:</b><br/>
Underdevelopment

<b>Disclaimer:</b><br/>
This project belongs to my personal property. However, I would be very happy if any developers out there find this project interesting and want to contribute. You can use my code for further analysis if only there is a link to this Github directory included or displayed in your application.

<b/>Important folders:</b><br/>
- database/euro: test data from European database.<br/>
https://physionet.org/physiobank/database/edb/
- ecg-kit-0.1.6: ECG wrapper code used in this thesis, written by Marianux.<br/>
http://marianux.github.io/ecg-kit/
- recordings: output data captured during algorithm design
- results: image captured from the outcome of the algorithm
- research\Prethesis\HK2: articles and documentation about this project<br/>
PRETHESIS REPORT.pdf, QUANTIFYING MYOCARDIAL DAMAGE USING ECG SIGNAL.pptx
- code files: Matlab .m files

<b/>Research methodologies:</b><br/>
1. Signal preprocessing:
- Baseline wander removal and noise estimation using Discrete Wavelet Decomposition
2. EKG delineation:
- Self constructed R peak and T peak detection: code can be found in REPORT.m, WAVELET.m or link here:<br/>
- ST segment detection
3. Features extraction:
- Window length of 10 seconds
- ST deviation and ST slope calibration for each beat, then calculate mean value for the 10 second span
- Applied Detrended FLuctuation Analysis to the beat to beat segment, then calculate mean value for the 10 second span
4. Thresholding:
- ST segment elevation Myocardial Infarction: ST deviation > 40 and ST slope > 6, with or without DFA higher than 1
- ST segment depression Myocardial Infarction: ST deviation < -20 and ST slope < -4, with or without DFA higher than 1
- Myocardial Ischemia: T wave inversion, with or without ST deviation < -20
- Normal subject: ST deviation < 40 and > -20, ST slope < 6 and > -4, DFA < 1
5. Validation:
- Thresholds obtained is compared and adjusted according to American Heart Association (AHA) guideline for myocardial infarction
- Still underdevelopment and validation...

<b/>Implementations:</b><br/>
- Real time application web service will locate at:<br/>
http://www.cassandra.com.vn/
- Cross platform application development: Android, iOS
- Desktop application: Matlab runtime

For further information, please contact:
Phạm Khôi Nguyên
phamkhoinguyen1995@gmail.com
