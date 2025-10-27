{
  description = "Machine Learning Development Environment with Multiple Conda Environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;  # For CUDA and some ML packages
          };
        };

        # Python environment with core ML packages (CPU-optimized)
        mlCpuEnv = pkgs.python3.withPackages (ps: with ps; [
          # Core scientific computing
          numpy
          scipy
          pandas
          matplotlib
          seaborn
          plotly
          
          # Machine learning
          scikit-learn
          statsmodels
          xgboost
          lightgbm
          
          # Jupyter and notebooks
          jupyter
          jupyterlab
          ipykernel
          ipywidgets
          
          # Data processing
          h5py
          tables
          pyarrow
          
          # Utilities
          tqdm
          click
          pyyaml
        ]);

        # Python environment with deep learning frameworks (GPU-capable)
        mlGpuEnv = pkgs.python3.withPackages (ps: with ps; [
          # Inherit ML-CPU packages
          numpy
          scipy
          pandas
          matplotlib
          seaborn
          scikit-learn
          
          # Deep learning frameworks
          tensorflow
          pytorch
          torchvision
          keras
          
          # Jupyter
          jupyter
          jupyterlab
          ipykernel
          
          # Additional DL tools
          h5py
          pillow
          opencv4
          
          # Utilities
          tqdm
          pyyaml
        ]);

      in
      {
        # Development shells for different environments
        devShells = {
          # Default shell with base tools
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # Core tools
              git
              wget
              curl
              vim
              
              # Python with Jupyter
              (python3.withPackages (ps: with ps; [
                jupyter
                jupyterlab
                ipykernel
                numpy
                pandas
                matplotlib
              ]))
              
              # Additional utilities
              tree
              htop
            ];
            
            shellHook = ''
              echo "🚀 Machine Learning Development Environment (Base)"
              echo "==============================================="
              echo ""
              echo "Available environments:"
              echo "  nix develop .#ml-cpu    - CPU-optimized ML (scikit-learn, pandas, XGBoost)"
              echo "  nix develop .#ml-gpu    - GPU-accelerated DL (TensorFlow, PyTorch)"
              echo "  nix develop .#r-stats   - R programming with statistical packages"
              echo ""
              echo "Start Jupyter Lab:"
              echo "  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
              echo ""
            '';
          };

          # ML-CPU environment
          ml-cpu = pkgs.mkShell {
            buildInputs = with pkgs; [
              mlCpuEnv
              git
              wget
              curl
              vim
              graphviz
              ffmpeg
            ];
            
            shellHook = ''
              echo "🤖 ML-CPU Environment Active"
              echo "============================="
              echo ""
              echo "Installed packages:"
              echo "  - NumPy, SciPy, Pandas"
              echo "  - Scikit-learn, XGBoost, LightGBM"
              echo "  - Matplotlib, Seaborn, Plotly"
              echo "  - Jupyter Lab"
              echo ""
              echo "Start Jupyter:"
              echo "  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
              echo ""
            '';
          };

          # ML-GPU environment with CUDA support
          ml-gpu = pkgs.mkShell {
            buildInputs = with pkgs; [
              mlGpuEnv
              git
              wget
              curl
              vim
              graphviz
              ffmpeg
              cudaPackages.cudatoolkit
              cudaPackages.cudnn
            ];
            
            shellHook = ''
              echo "🚀 ML-GPU Environment Active (CUDA Enabled)"
              echo "==========================================="
              echo ""
              echo "Installed frameworks:"
              echo "  - TensorFlow 2.x"
              echo "  - PyTorch 1.x"
              echo "  - Keras"
              echo ""
              echo "CUDA support: ${pkgs.cudaPackages.cudatoolkit.version}"
              echo ""
              echo "Start Jupyter:"
              echo "  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
              echo ""
            '';
          };

          # R statistics environment
          r-stats = pkgs.mkShell {
            buildInputs = with pkgs; [
              (rWrapper.override {
                packages = with rPackages; [
                  # Core R packages
                  ggplot2
                  dplyr
                  tidyr
                  readr
                  tibble
                  
                  # Statistics
                  lme4
                  nlme
                  survival
                  caret
                  
                  # Machine learning
                  randomForest
                  xgboost
                  glmnet
                  
                  # Jupyter integration
                  IRkernel
                  
                  # Utilities
                  devtools
                  rmarkdown
                  knitr
                ];
              })
              
              git
              wget
              curl
              vim
            ];
            
            shellHook = ''
              echo "📊 R Statistics Environment Active"
              echo "=================================="
              echo ""
              echo "Installed packages:"
              echo "  - tidyverse (ggplot2, dplyr, tidyr, readr)"
              echo "  - Statistical models (lme4, nlme, survival)"
              echo "  - ML packages (randomForest, xgboost, caret)"
              echo "  - IRkernel for Jupyter integration"
              echo ""
              echo "Start R:"
              echo "  R"
              echo ""
              echo "Start Jupyter with R kernel:"
              echo "  jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
              echo ""
            '';
          };
        };

        # Packages that can be built
        packages = {
          default = mlCpuEnv;
          ml-cpu = mlCpuEnv;
          ml-gpu = mlGpuEnv;
        };
      }
    );
}
