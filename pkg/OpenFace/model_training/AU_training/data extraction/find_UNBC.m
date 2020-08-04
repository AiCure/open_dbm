if(exist('D:\Datasets\UNBC/', 'file'))
    UNBC_dir = 'E:\Datasets\UNBC/';   
elseif(exist('E:\Datasets\UNBC/', 'file'))
    UNBC_dir = 'E:\Datasets\UNBC/';   
else
    fprintf('UNBC location not found (or not defined)\n'); 
end

all_recs = {'042-ll042', '043-jh043', '047-jl047', '048-aa048', '049-bm049',...
            '052-dr052', '059-fn059', '064-ak064', '066-mg066', '080-bn080',...
            '092-ch092', '095-tv095', '096-bg096', '097-gf097', '101-mg101',...
            '103-jk103', '106-nm106', '107-hs107', '108-th108', '109-ib109',...
            '115-jy115', '120-kz120', '121-vw121', '123-jh123', '124-dn124'};
        
devel_recs = all_recs(1:5:25);
train_recs = setdiff(all_recs, devel_recs);

all_aus = [4, 6, 7, 9, 10, 12, 20, 25, 26, 43];