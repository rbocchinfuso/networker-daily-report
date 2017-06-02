# NetWorker Daily Status Report

Creates a HTML formatted daily backup status report and sends via Email.

## Requirements
- Java
- Powershell
- Networker Management Console (NMC)
- JAVA_HOME must be set in gstclreport.bat script

## Installation

- Download code from GitHub
    - _Note:  If you don't have Git installed you can also just grab the zip:  https://github.com/rbocchinfuso/networker-daily-report/archive/master.zip_
```
    git clone https://github.com/rbocchinfuso/networker-daily-report.git
```

- Update variables in nw_vars.txt file.  You should update the following sections:
    - Environment Info
    - NMC Credentials
    - Report Output Location
    - Mail Settings

    _Note: The "Report Generation Section" can be left unedited unless you are looking to alter the type of report generated.  This will also require that modifciations are made to the nw_daily_rpt_ps1 script_


## Usage

- From Powershell command prompt
```
    ./nw_daily_rpt.ps1
```
- From Windows command prompt or from task scheduler
```
    start powershell "& "./nw_daily_rpt.ps1"
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

- version 0.1 (initial release) - 2014/10/23
- version 0.2 (cleaned up code and documentation) - 2016/12/20

## Credits

Rich Bocchinfuso <<rbocchinfuso@gmail.com>>


## License

MIT License

Copyright (c) [2016] [Richard J. Bocchinfuso]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.