function ttt=im2col_inds(a, block)
%IM2COL Rearrange image blocks into columns.
%   B = IM2COL(A,[M N],'distinct') rearranges each distinct
%   M-by-N block in the image A into a column of B. IM2COL pads A
%   with zeros, if necessary, so its size is an integer multiple
%   of M-by-N. If A = [A11 A12; A21 A22], where each Aij is
%   M-by-N, then B = [A11(:) A21(:) A12(:) A22(:)].
%
%   B = IM2COL(A,[M N],'sliding') converts each sliding M-by-N
%   block of A into a column of B, with no zero padding. B has
%   M*N rows and will contain as many columns as there are M-by-N
%   neighborhoods in A. If the size of A is [MM NN], then the
%   size of B is (M*N)-by-((MM-M+1)*(NN-N+1). Each column of B
%   contains the neighborhoods of A reshaped as NHOOD(:), where
%   NHOOD is a matrix containing an M-by-N neighborhood of
%   A. IM2COL orders the columns of B so that they can be
%   reshaped to form a matrix in the normal way. For example,
%   suppose you use a function, such as SUM(B), that returns a
%   scalar for each column of B. You can directly store the
%   result in a matrix of size (MM-M+1)-by-(NN-N+1) using these
%   calls:
%
%        B = im2col(A,[M N],'sliding');
%        C = reshape(sum(B),MM-M+1,NN-N+1);
%
%   B = IM2COL(A,[M N]) uses the default block type of
%   'sliding'.
%
%   B = IM2COL(A,'indexed',...) processes A as an indexed image,
%   padding with zeros if the class of A is uint8 or uint16, or
%   ones if the class of A is double.
%
%   Class Support
%   -------------
%   The input image A can be numeric or logical. The output matrix
%   B is of the same class as the input image.
%
%   Example
%   -------
%   Calculate the local mean using a [2 2] neighborhood with zero padding.
%
%       A = reshape(linspace(0,1,16),[4 4])'
%       B = im2col(A,[2 2])
%       M = mean(B)
%       newA = col2im(M,[1 1],[3 3])
%
%   See also BLOCKPROC, COL2IM, COLFILT, NLFILTER.

%   Copyright 1993-2016 The MathWorks, Inc.

[ma,na] = size(a);
m = block(1); n = block(2);

if any([ma na] < [m n]) % if neighborhood is larger than image
    b = zeros(m*n,0);
    return
end

% Create Hankel-like indexing sub matrix.
mc = block(1); nc = ma-m+1; nn = na-n+1;
cidx = (0:mc-1)'; ridx = 1:nc;
t = cidx(:,ones(nc,1)) + ridx(ones(mc,1),:);    % Hankel Subscripts
tt = zeros(mc*n,nc);
rows = 1:mc;
for i=0:n-1,
    tt(i*mc+rows,:) = t+ma*i;
end
ttt = zeros(mc*n,nc*nn);
cols = 1:nc;
for j=0:nn-1,
    ttt(:,j*nc+cols) = tt+ma*j;
end
    

%%%
%%% Function parse_inputs
%%%
function [a, block, kind, padval] = parse_inputs(varargin)

narginchk(2,4);

switch nargin
    case 2
        if (strcmp(varargin{2},'indexed'))
            error(message('images:im2col:tooFewInputs'))
        else
            % IM2COL(A, [M N])
            a = varargin{1};
            block = varargin{2};
            kind = 'sliding';
            padval = 0;
        end
        
    case 3
        if (strcmp(varargin{2},'indexed'))
            % IM2COL(A, 'indexed', [M N])
            a = varargin{1};
            block = varargin{3};
            kind = 'sliding';
            padval = 1;
        else
            % IM2COL(A, [M N], 'kind')
            a = varargin{1};
            block = varargin{2};
            kind = validatestring(varargin{3},{'sliding','distinct'},mfilename,'kind',3);
            padval = 0;
        end
        
    case 4
        % IM2COL(A, 'indexed', [M N], 'kind')
        a = varargin{1};
        block = varargin{3};
        kind = validatestring(varargin{4},{'sliding','distinct'},mfilename,'kind',4);
        padval = 1;
        
end

if (isa(a,'uint8') || isa(a, 'uint16'))
    padval = 0;
end
