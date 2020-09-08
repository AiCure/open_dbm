function setup(varargin)

try
    run D:\soft\matconvnet-master\matconvnet-master\matlab/vl_setupnn ;
    addpath D:\soft\matconvnet-master\matconvnet-master\examples ;

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
catch
   fprintf('Could not setup MatConvNet, face detection will be slower, install the library and set the right location for it in setup_mconvnet.m\n');
end