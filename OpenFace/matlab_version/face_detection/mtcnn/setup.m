function setup(varargin)

addpath C:\matconvnet\matconvnet-1.0-beta25\examples;

opts.useGpu = false ;
opts.verbose = false ;
opts = vl_argparse(opts, varargin) ;

try
  vl_nnconv(single(1),single(1),[]) ;
catch
  warning('VL_NNCONV() does not seem to be compiled. Trying to compile it now.') ;
  vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose) ;
end

if opts.useGpu
  try
    vl_nnconv(gpuArray(single(1)),gpuArray(single(1)),[]) ;
  catch
    vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose) ;
    warning('GPU support does not seem to be compiled in MatConvNet. Trying to compile it now') ;
  end
end
