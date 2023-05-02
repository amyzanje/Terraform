@echo off
setlocal EnableDelayedExpansion

echo off > terraform.tfvars
set input_file=data.csv
set output_file=terraform.tfvars


for /F "tokens=1,2 delims=," %%a in (%input_file%) do (
    set "key=%%a"
    set "value=%%b"
    if %%b EQU TRUE (
    echo !key! = !value! >> %output_file%
    ) else if %%b EQU FALSE (
      echo !key! = !value! >> %output_file%  
    ) else (
      echo !key! = "!value!" >> %output_file%  
    )
    
)

echo Conversion complete!