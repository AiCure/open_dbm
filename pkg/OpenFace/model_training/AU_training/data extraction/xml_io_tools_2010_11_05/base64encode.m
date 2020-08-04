function y = base64encode(x, alg, isChunked, url_safe)
%BASE64ENCODE Perform base64 encoding on a string.
% INPUT:
%   x    - block of data to be encoded.  Can be a string or a numeric
%          vector containing integers in the range 0-255.
%   alg  - Algorithm to use: can take values 'java' or 'matlab'. Optional
%          variable defaulting to 'java' which is a little faster. If
%          'java' is chosen than core of the code is performed by a call to
%          a java library. Optionally all operations can be performed using
%          matleb code.
%   isChunked - encode output into 76 character blocks. The returned 
%          encoded string is broken into lines of no more than
%          76 characters each, and each line will end with EOL. Notice that
%          if resulting string is saved as part of an xml file, those EOL's
%          are often stripped by xmlwrite funtrion prior to saving.      
%   url_safe - use Modified Base64 for URL applications ('base64url'
%   encoding) "Base64 alphabet" ([A-Za-z0-9-_=]). 
%
%
% OUTPUT:
%   y    - character array using only "Base64 alphabet" characters 
%
%   This function may be used to encode strings into the Base64 encoding
%   specified in RFC 2045 - MIME (Multipurpose Internet Mail Extensions).  
%   The Base64 encoding is designed to represent arbitrary sequences of 
%   octets in a form that need not be humanly readable.  A 65-character 
%   subset ([A-Za-z0-9+/=]) of US-ASCII is used, enabling 6 bits to be 
%   represented per printable character.
%
%   See also BASE64DECODE.
%
%   Written by Jarek Tuszynski, SAIC, jaroslaw.w.tuszynski_at_saic.com
%
%   Matlab version based on 2004 code by Peter J. Acklam
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam
%   http://home.online.no/~pjacklam/matlab/software/util/datautil/base64encode.m

if nargin<2, alg='java';      end
if nargin<3, isChunked=false; end
if ~islogical(isChunked) 
  if isnumeric(isChunked)
    isChunked=(isChunked>0);
  else
    isChunked=false;
  end 
end
if nargin<4, url_safe=false; end
if ~islogical(url_safe) 
  if isnumeric(url_safe)
    url_safe=(url_safe>0);
  else
    url_safe=false;
  end 
end


%% if x happen to be a filename than read the file
if (numel(x)<256)
  if (exist(x, 'file')==2)
    fid = fopen(x,'rb');
    x = fread(fid, 'uint8');             % read image file as a raw binary
    fclose(fid);
  end
end

%% Perform conversion
switch (alg)
  case 'java'
    base64 = org.apache.commons.codec.binary.Base64;
    y = base64.encodeBase64(x, isChunked); 
    if url_safe
      y = strrep(y,'=','-');
      y = strrep(y,'/','_');
    end
    
  case 'matlab'
    
    %% add padding if necessary, to make the length of x a multiple of 3
    x   = uint8(x(:));
    ndbytes = length(x);                 % number of decoded bytes
    nchunks = ceil(ndbytes / 3);         % number of chunks/groups
    if rem(ndbytes, 3)>0
      x(end+1 : 3*nchunks) = 0;          % add padding
    end
    x = reshape(x, [3, nchunks]);        % reshape the data
    y = repmat(uint8(0), 4, nchunks);    % for the encoded data
    
    %% Split up every 3 bytes into 4 pieces
    %    aaaaaabb bbbbcccc ccdddddd
    % to form
    %    00aaaaaa 00bbbbbb 00cccccc 00dddddd
    y(1,:) = bitshift(x(1,:), -2);                  % 6 highest bits of x(1,:)
    y(2,:) = bitshift(bitand(x(1,:), 3), 4);        % 2 lowest  bits of x(1,:)
    y(2,:) = bitor(y(2,:), bitshift(x(2,:), -4));   % 4 highest bits of x(2,:)
    y(3,:) = bitshift(bitand(x(2,:), 15), 2);       % 4 lowest  bits of x(2,:)
    y(3,:) = bitor(y(3,:), bitshift(x(3,:), -6));   % 2 highest bits of x(3,:)
    y(4,:) = bitand(x(3,:), 63);                    % 6 lowest  bits of x(3,:)
    
    %% Perform the mapping
    %   0  - 25  ->  A-Z
    %   26 - 51  ->  a-z
    %   52 - 61  ->  0-9
    %   62       ->  +
    %   63       ->  /
    map = ['A':'Z', 'a':'z', '0':'9', '+/'];
    if (url_safe), map(63:64)='-_'; end
    y = map(y(:)+1);
    
    %% Add padding if necessary.
    npbytes = 3 * nchunks - ndbytes;    % number of padding bytes
    if npbytes>0
      y(end-npbytes+1 : end) = '=';     % '=' is used for padding
    end
    
    %% break into lines with length LineLength
    if (isChunked)
      eol = sprintf('\n');
      nebytes = numel(y);
      nlines  = ceil(nebytes / 76);     % number of lines
      neolbytes = length(eol);          % number of bytes in eol string
      
      % pad data so it becomes a multiple of 76 elements
      y(nebytes + 1 : 76 * nlines) = 0;
      y = reshape(y, 76, nlines);
      
      % insert eol strings
      y(end + 1 : end + neolbytes, :) = eol(:, ones(1, nlines));
      
      % remove padding, but keep the last eol string
      m = nebytes + neolbytes * (nlines - 1);
      n = (76+neolbytes)*nlines - neolbytes;
      y(m+1 : n) = [];
    end
end

%% reshape to a row vector and make it a character array
y = char(reshape(y, 1, numel(y)));
