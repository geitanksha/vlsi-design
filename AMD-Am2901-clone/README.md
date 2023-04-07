#AMD-Am2901-clone

Creating a clone of the AMD Am2901 chip's datapath and controller using CMOS technology. 


<img width="1010" alt="image" src="https://user-images.githubusercontent.com/93052774/230678209-c71f6c6c-18d8-47b6-953f-d5ad077ae888.png">


<img width="576" alt="image" src="https://user-images.githubusercontent.com/93052774/230678282-4d0c74f1-df72-4120-b1a6-076d81289163.png">

(All rights reserved for the following images: _The Am2900 Family Data Book_)

Primary Components:
Main components
- Register file, or "16x4 bit 2-port RAM"
- Q register
- ALU
Additional components
- Multiplexers (2-input, 3-input, 4-input)

<img width="750" alt="image" src="https://user-images.githubusercontent.com/93052774/230678626-9c95b56e-38c4-4d61-8ad6-47081cbb737e.png">
<img width="758" alt="image" src="https://user-images.githubusercontent.com/93052774/230678635-c26146c6-6c6b-420c-af5c-36951c00b9b9.png">

Controller implemented in controller.v, and top-level logic in Am2901.v.
