cd lib/local/LandmarkDetector/model/patch_experts

wget https://www.dropbox.com/s/7na5qsjzz8yfoer/cen_patches_0.25_of.dat
if [ $? -ne 0 ]
then
  wget https://onedrive.live.com/download?cid=2E2ADA578BFF6E6E&resid=2E2ADA578BFF6E6E%2153072&authkey=AKqoZtcN0PSIZH4
fi

wget https://www.dropbox.com/s/k7bj804cyiu474t/cen_patches_0.35_of.dat
if [ $? -ne 0 ]
then
  wget https://onedrive.live.com/download?cid=2E2ADA578BFF6E6E&resid=2E2ADA578BFF6E6E%2153079&authkey=ANpDR1n3ckL_0gs
fi

wget https://www.dropbox.com/s/ixt4vkbmxgab1iu/cen_patches_0.50_of.dat
if [ $? -ne 0 ]
then
  wget https://onedrive.live.com/download?cid=2E2ADA578BFF6E6E&resid=2E2ADA578BFF6E6E%2153074&authkey=AGi-e30AfRc_zvs
fi

wget https://www.dropbox.com/s/2t5t1sdpshzfhpj/cen_patches_1.00_of.dat
if [ $? -ne 0 ]
then
  wget https://onedrive.live.com/download?cid=2E2ADA578BFF6E6E&resid=2E2ADA578BFF6E6E%2153070&authkey=AD6KjtYipphwBPc
fi

cd ../../../../../
