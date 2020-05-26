# Thesis-Publication

My thesis "A decision-support framework for techno-economic-sustainability assessment of resource recovery alternatives" has been published in the Journal of Cleaner Production and can't be found here; [Paper](https://www.sciencedirect.com/science/article/pii/S0959652620319016)  

<p align="center">
  <img src="https://github.com/silkdom/Thesis-Publication/blob/master/img/JCLP.png?raw=true" alt="JCLP"/>
</p>

This repo regards the software implementation of the framework.

## Motivation
Upon reflecting on the finished framework, it was clear that the efforts to uphold comprehensiveness could potential be perceived as a downfall, in respect to the number of challenges that arise when attempting to apply manually, namely the complexity and time it takes to apply. This is an unintended consequence, as the framework was envisioned to aid users quickly through the resource recovery potential identification process. Consequently, computer aided functionalities were deemed as a necessary addition to streamline the process, thus TaskGen was conceived.

## Overview
TaskGen is a tool created to aid users through the conceived resource recovery framework. When using the tool many of the aforementioned framework steps can be completed rapidly with use of the tool, thus drastically decreasing complexity and increasing ease of application. TaskGen facilitates swift generation of feasible flowsheets, thus allowing users to assess possibilities that may not have been previously considered, and eliminate unsuitable candidates early the evaluation process. A demonstration of how framework implementation is assisted with the use of TaskGen can be seen as follows;

![](img/Ethanol.gif)

## Installation
1. Save all files (Flowsheet_master.xlsm, Masterfunc.m, and fsort.m) in the same folder. If the files
are saved in a folder that’s pathway has already been synced to MATLAB, step 7 is not necessary.
For DTU users: C:\Users\‘studentnumber’\Documents\MATLAB where, ‘studentnumber’ is
the users student number (E.g. s162418).

1. Open Flowsheet_master.xlsm
1. Select file, click options then Add-ins. In the manage Excel Add-ins box select Go…
1. Click browse, find the excellink Add-in, and click OK. The pathway for DTU computers is:
C:\Program Files\MatLab R2017a\toolbox\exlink\exllink.xlam
1. If cell W3 in the Dashboard tab displays #COMMAND!, the connection is successful. If it says
#NAME, check the file extension in W3 matches the one found in step 4.
1. Now open Masterfunc.m and fsort.m in MATLAB.
1. Select the HOME tab, then Set Path. Click Add Folder… and find the folder that the files were
saved in step 1. Select the folder and try to save. If prompted for administrator permission click
No, followed by Close, and No again. This means that step 7 will have to be repeated for each
usage session.
1. Click Generate flowsheet for one of the example cases. If cell X3 in the Dashboard tab states that
the tool is working, installation is complete.
1. If the intention is to understand the tool and generate flowsheets for the example cases, proceed to
the “Functionalities” section. If the user wants to apply the tool to their own case, see the “Case set
up” section

## Case Initialization
1. Obtain property information from literature or from PrePred using the group contribution method.
Suffice remaining properties with condition dependent correlations.

1. Open TaskGen and go to the input all tab
1. Find an empty input bay in the stream characterization section AQ:BR. Assign numerical indicators
to the case relevant components and input the concentration, flowrate, and price. Name the case in
the cell above “compound”.
1. Find the empty input bay with the matching name in the property information section A:AO. Enter
the property information in the required single-entry format.
1. If a reaction occurs in the case, find the empty input bay in the Rxn section BS:CF. Eneter the type
of reaction, reactants, and products. Assign numerical indicators to the products and calculate the
unique product of the reactant’s indictors in cell BT7. Enter the product property information in
section CH:CL in the same manner as step 4.
1. Return to the TaskGen dashboard tab and select the relevant case in cell U3. If a reaction is
occurring, select the relevant type in cell U17.
1. Check that the program is working. If the cell X3 it is not displaying “Yes”, revert to the installation
section and verify that the process has been followed correctly.
1. Press the “Clear” button to erase previous cases results.

## TaskGen Usage
