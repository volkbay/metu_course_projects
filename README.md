# metu_course_projects
My parts of the term projects assigned in the scope of university courses.

<details>
  <summary>EEE Undergraduate Capstone Project</summary>
  
  ## Undergraduate Capstone Project: 3-ball Playing Robot
  https://user-images.githubusercontent.com/97564250/236216379-7402f908-63a5-4388-bbc0-949204c5af0e.mp4
  
  I was in a team of six people and my responsibility was to detect location and colors of the 3 ball by the top view camera. The objective is to hit the cue ball (red  one in following examples) to touch other two balls. The shooting angle calculation are also shown by two lines: one for cueing towards the second ball and one for hitting the third after reflection. The robot is mobile and freely moving, that is communicated with Matlab host via bluetooth.
  
  > Relevant content is [here](/metu_eee_undergrad_capstone). The code is not compiled, should be run in MATLAB 2016a or later.
  
  >**Note** I also made a GUI to select cue ball, to observe images and to give hit command. The GUI related files are `ErasmusPlusOne`, but it will not work properly without other components of the project. If you would like try CV output only, run `capstone_cv_part`.

  <p float="left">
    <img src="https://user-images.githubusercontent.com/97564250/236222004-c8ace175-8294-4a20-865e-755506fa6e95.jpg" width="43%">
    <img src="https://user-images.githubusercontent.com/97564250/236222017-af5ba922-c678-4373-b9c0-d3e800f79d1c.jpg" width="48%">
    <img src="https://user-images.githubusercontent.com/97564250/236222011-80cfbab7-4f5e-4390-a6c1-244171c66e84.jpg" width="43%">
    <img src="https://user-images.githubusercontent.com/97564250/236222021-cb4d181c-f860-4c6b-89c0-85f68f214073.jpg" width="48%">
    <img src="https://user-images.githubusercontent.com/97564250/236222016-2d973268-2620-4c37-be5b-c20e067cad9d.jpg" width="43%">
    <img src="https://user-images.githubusercontent.com/97564250/236222024-3f69e7c2-c26b-4b44-b132-3610ed860ade.jpg" width="48%">
  </p>
  
  _Figure: Input images from top view camera and resulting images of located balls with calculated hitting angles_


</details>



