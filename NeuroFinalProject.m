%% Group 1: 3+ drinks


addpath('/Users/teja/Documents/MATLAB/Default dataset')
participants = {'sub-01', 'sub-04', 'sub-07', 'sub-09', 'sub-10', 'sub-14', 'sub-17', 'sub-18', 'sub-20', 'sub-21', 'sub-25', 'sub-26'};

total_la_wm_vol = 0;
total_ra_wm_vol = 0;
total_la_gm_vol = 0;
total_ra_gm_vol = 0;

%Loop

for i = 1:length(participants)
   participant = participants{i};
  
   %Left Amygdala Mask
   aparc18= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
   aparc18(find(aparc18~=18))=0;
   aparc18(find(aparc18~=0))=1;
   sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
   sub01t1w_la=sub01t1w.*aparc18;
   mean_la=mean(sub01t1w_la,"all");
   disp(['G1: Mean left ', participant, ': ', num2str(mean_la)]);
 
   % Right Amygdala Mask
   aparc54= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
   aparc54(find(aparc54~=54))=0;
   aparc54(find(aparc54~=0))=1;
   sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
   sub01t1w_ra=sub01t1w.*aparc54;
   mean_ra=mean(sub01t1w_ra,"all");
   disp(['G1: Mean right ', participant, ': ', num2str(mean_ra)]);


    %White Matter
    wmT1=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/c2sr', participant, '_PET.nii']));
    wmT1(find(wmT1<0.8))=0;
    wmT1(find(wmT1>=0.8))=1;
    aparc18_wm=sub01t1w_la.*wmT1;
    aparc54_wm=sub01t1w_ra.*wmT1;
    la_wm_mean=mean(aparc18_wm,"all");
    ra_wm_mean=mean(aparc54_wm,"all");
    disp(['G1: Mean white matter ', participant, ': ', num2str(la_wm_mean), ' (Left), ', num2str(ra_wm_mean), ' (Right)']);
      
    %Gray Matter
    gmT1=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/c1sr', participant, '_PET.nii']));
    gmT1(find(gmT1<0.8))=0;
    gmT1(find(gmT1>=0.8))=1;
    aparc18_gm=sub01t1w_la.*gmT1;
    aparc54_gm=sub01t1w_ra.*gmT1;
    la_gm_mean=mean(aparc18_gm,"all");
    ra_gm_mean=mean(aparc54_gm,"all");
    disp(['G1: Mean gray matter ', participant, ': ', num2str(la_gm_mean), ' (Left), ', num2str(ra_gm_mean), ' (Right)']);
      
    %Volume White Matter
    la_wm_vol = length(find(aparc18_wm));
    ra_wm_vol = length(find(aparc54_wm));
    disp(['G1: Volume of white matter ', participant, ': ', num2str(la_wm_vol), ' (Left), ', num2str(ra_wm_vol), ' (Right)']);
      
    %Volume Gray Matter
    la_gm_vol=length(find(aparc18_gm));
    ra_gm_vol=length(find(aparc54_gm));
    disp(['G1: Volume of gray matter ', participant, ': ', num2str(la_gm_vol), ' (Left), ', num2str(ra_gm_vol), ' (Right)']);
    
    %Total volumes
    total_la_wm_vol = total_la_wm_vol + la_wm_vol;
    total_ra_wm_vol = total_ra_wm_vol + ra_wm_vol;
    total_la_gm_vol = total_la_gm_vol + la_gm_vol;
    total_ra_gm_vol = total_ra_gm_vol + ra_gm_vol;
end

%Mean volumes
mean_wm_vol_G1 = (total_la_wm_vol + total_ra_wm_vol) / length(participants);
mean_gm_vol_G1 = (total_la_gm_vol + total_ra_gm_vol) / length(participants);

disp(['G1:Mean volume of white matter: ', num2str(mean_wm_vol_G1)]);
disp(['G1:Mean volume of gray matter: ', num2str(mean_gm_vol_G1)]);
%% Amygdala Mask on MRI - G1

%Left amygdala
aparc_left = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/sub-01_T1w_aparc_aseg.nii']));
left_mask = (aparc_left == 18); 
aparc_left(find(aparc_left~=18))=0;
aparc_left(find(aparc_left~=0))=1;
sub01t1w_la=left_mask.*aparc_left;


%Right amygdala
aparc_right = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/sub-01_T1w_aparc_aseg.nii']));
right_mask = (aparc_right == 54); 
aparc_right(find(aparc_right~=54))=0;
aparc_right(find(aparc_right~=0))=1;
sub01t1w_ra=right_mask.*aparc_right;


%Combine left and right
amygdala_mask = sub01t1w_la + sub01t1w_ra;

sub01t1w = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Real Sub MRI/sub-01_T1w_brain.nii']));
sub01t1w_left = sub01t1w .* sub01t1w_la;
sub01t1w_right = sub01t1w .* sub01t1w_ra;

sub01t1w_whole = sub01t1w_left + sub01t1w_right;

%Masked Image
figure;
a = squeeze(sub01t1w_whole(:,:,128));
b = squeeze(sub01t1w(:,:,128));
image = imrotate(imfuse(a,b),270);
imshow(image, []);
title('Amygdala Mask on MRI - Sub01');
%% Group 2: 2> drinks


addpath('/Users/teja/Documents/MATLAB/Default dataset')
participants = {'sub-02', 'sub-03', 'sub-05', 'sub-06', 'sub-08', 'sub-11', 'sub-12', 'sub-13', 'sub-15', 'sub-16', 'sub-19', 'sub-22', 'sub-23', 'sub-24'};

total_la_wm_vol = 0;
total_ra_wm_vol = 0;
total_la_gm_vol = 0;
total_ra_gm_vol = 0;

%Loop

for i = 1:length(participants)
   participant = participants{i};
  
  
   %Left Mask
   aparc_left= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
   aparc_left(find(aparc_left~=18))=0;
   aparc_left(find(aparc_left~=0))=1;
   sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
   sub01t1w_la=sub01t1w.*aparc_left;
   mean_la=mean(sub01t1w_la,"all");
   disp(['G2: Mean left ', participant, ': ', num2str(mean_la)]);
 
  
   %Right Mask
   aparc54= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
   aparc54(find(aparc54~=54))=0;
   aparc54(find(aparc54~=0))=1;
   sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
   sub01t1w_ra=sub01t1w.*aparc54;
   mean_ra=mean(sub01t1w_ra,"all");
   disp(['G2: Mean right ', participant, ': ', num2str(mean_ra)]);
  
   %White Matter
   wmT1=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/c2sr', participant, '_PET.nii']));
   wmT1(find(wmT1<0.8))=0;
   wmT1(find(wmT1>=0.8))=1;
   aparc18_wm=sub01t1w_la.*wmT1;
   aparc54_wm=sub01t1w_ra.*wmT1;
   la_wm_mean=mean(aparc18_wm,"all");
   ra_wm_mean=mean(aparc54_wm,"all");
   disp(['G2: Mean white matter ', participant, ': ', num2str(la_wm_mean), ' (Left), ', num2str(ra_wm_mean), ' (Right)']);
  
   %Gray Matter
   gmT1=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/c1sr', participant, '_PET.nii']));
   gmT1(find(gmT1<0.8))=0;
   gmT1(find(gmT1>=0.8))=1;
   aparc18_gm=sub01t1w_la.*gmT1;
   aparc54_gm=sub01t1w_ra.*gmT1;
   la_gm_mean=mean(aparc18_gm,"all");
   ra_gm_mean=mean(aparc54_gm,"all");
   disp(['G2: Mean gray matter ', participant, ': ', num2str(la_gm_mean), ' (Left), ', num2str(ra_gm_mean), ' (Right)']);
  
   %Volume White Matter
   la_wm_vol = length(find(aparc18_wm));
   ra_wm_vol = length(find(aparc54_wm));
   disp(['G2: Volume of white matter ', participant, ': ', num2str(la_wm_vol), ' (Left), ', num2str(ra_wm_vol), ' (Right)']);
  
   %Volume Gray Matter
   la_gm_vol=length(find(aparc18_gm));
   ra_gm_vol=length(find(aparc54_gm));
   disp(['G2: Volume of gray matter ', participant, ': ', num2str(la_gm_vol), ' (Left), ', num2str(ra_gm_vol), ' (Right)']);

   %Total volumes
   total_la_wm_vol = total_la_wm_vol + la_wm_vol;
   total_ra_wm_vol = total_ra_wm_vol + ra_wm_vol;
   total_la_gm_vol = total_la_gm_vol + la_gm_vol;
   total_ra_gm_vol = total_ra_gm_vol + ra_gm_vol;
end

%Mean volumes
mean_wm_vol_G2 = (total_la_wm_vol + total_ra_wm_vol) / length(participants);
mean_gm_vol_G2 = (total_la_gm_vol + total_ra_gm_vol) / length(participants);

disp(['G2:Mean volume of white matter: ', num2str(mean_wm_vol_G2)]);
disp(['G2:Mean volume of gray matter: ', num2str(mean_gm_vol_G2)]);
%% Amygdala mask on brain - G2 sub-02

%Aparc+aseg for left amygdala
aparc_left = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/sub-05_T1w_aparc_aseg.nii']));
left_mask = (aparc_left == 18); 
aparc_left(find(aparc_left~=18))=0;
aparc_left(find(aparc_left~=0))=1;
sub01t1w_la=left_mask.*aparc_left;


%Aparc+aseg for right amygdala
aparc_right = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/sub-05_T1w_aparc_aseg.nii']));
right_mask = (aparc_right == 54); 
aparc_right(find(aparc_right~=54))=0;
aparc_right(find(aparc_right~=0))=1;
sub01t1w_ra=right_mask.*aparc_right;


%Combine left and right
amygdala_mask = sub01t1w_la + sub01t1w_ra;

sub01t1w = spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Real Sub MRI/sub-05_T1w_brain.nii']));
sub01t1w_left = sub01t1w .* sub01t1w_la;
sub01t1w_right = sub01t1w .* sub01t1w_ra;

sub01t1w_whole = sub01t1w_left + sub01t1w_right;

%Masked image
figure;
a = squeeze(sub01t1w_whole(:,:,132));
b = squeeze(sub01t1w(:,:,132));
image = imrotate(imfuse(a,b),270);
imshow(image, []);
title('Amygdala Mask on MRI - Sub05');


%% G1 PET SUVr

addpath('/Users/teja/Documents/MATLAB/Default dataset')
participants = {'sub-01', 'sub-04', 'sub-07', 'sub-09', 'sub-10', 'sub-14', 'sub-17', 'sub-18', 'sub-20', 'sub-21', 'sub-25', 'sub-26'};

for i = 1:length(participants)
    participant = participants{i};

    brain = (spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii'])));
    mean_brain=mean(brain,"all");
    
    aparc_left= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
    aparc_left(find(aparc_left~=18))=0;
    aparc_left(find(aparc_left~=0))=1;
    sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
    sub01t1w_la=sub01t1w.*aparc_left;
    aparc54= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
    aparc54(find(aparc54~=54))=0;
    aparc54(find(aparc54~=0))=1;
    sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
    sub01t1w_ra=sub01t1w.*aparc54;
    sub01t1w_amy=(sub01t1w_la + sub01t1w_ra);
    mean_amy=mean(sub01t1w_amy, "all");
    
   

    PET_SUVr_sub01 = mean_amy/mean_brain;
    disp(['G1: PET SUVr', participant, ': ', num2str(PET_SUVr_sub01)])
end

%% G2 PET SUVr


addpath('/Users/teja/Documents/MATLAB/Default dataset')
participants = {'sub-02', 'sub-03', 'sub-05', 'sub-06', 'sub-08', 'sub-11', 'sub-12', 'sub-13', 'sub-15', 'sub-16', 'sub-19', 'sub-22', 'sub-23', 'sub-24'};

for i = 1:length(participants)
    participant = participants{i};

    brain = (spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii'])));
    mean_brain=mean(brain,"all");
    
    aparc_left= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
    aparc_left(find(aparc_left~=18))=0;
    aparc_left(find(aparc_left~=0))=1;
    sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
    sub01t1w_la=sub01t1w.*aparc_left;
    aparc54= spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/T1w MRI/', participant, '_T1w_aparc_aseg.nii']));
    aparc54(find(aparc54~=54))=0;
    aparc54(find(aparc54~=0))=1;
    sub01t1w=spm_read_vols(spm_vol(['/Users/teja/Documents/MATLAB/Default dataset/Updated_PET_Files_export/sr', participant , '_PET.nii']));
    sub01t1w_ra=sub01t1w.*aparc54;
    sub01t1w_amy=(sub01t1w_la + sub01t1w_ra);
    mean_amy=mean(sub01t1w_amy, "all");
    
   
    PET_SUVr_sub01 = mean_amy/mean_brain;
    disp(['G2: PET SUVr', participant, ': ', num2str(PET_SUVr_sub01)])
end








