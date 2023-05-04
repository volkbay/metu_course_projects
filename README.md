# <a href="https://www.metu.edu.tr/"><img align="right" src="https://user-images.githubusercontent.com/97564250/236304985-7013dd63-9f8f-4b7a-89aa-09cfe95219e0.png" width="30%"></a> My Projects from Courses at _Middle East Technical University_

My parts of the term projects assigned in the scope of university courses. Please click to unfold the section of each project for details.

<details>
  <summary>EEE Undergraduate Capstone Project</summary>
  
  ## Electrical-Electronics Eng. Undergraduate Capstone Project: 3-ball Playing Robot
  https://user-images.githubusercontent.com/97564250/236216379-7402f908-63a5-4388-bbc0-949204c5af0e.mp4
  
  I was in a team of six people and my responsibility was to detect location and colors of the 3 balls by the images acquired by a top view camera. The objective is to hit the cue ball (red one in the examples here) to touch other two balls. The shooting angle calculation are also shown by two lines: one for cueing towards the second ball and one for hitting the third after reflection. The robot is mobile and freely moving, that communicates with Matlab host via bluetooth.
  
  > Relevant content is [here](/metu_eee_undergrad_capstone). The code is not compiled, should be run in MATLAB 2016a or later.
  
  >**Note** I also made a GUI to select cue ball, to observe image-based calculations and to give hit command. The GUI related files are named as `ErasmusPlusOne`, but it will not work properly without other components of the project. If you would like try CV output only, run `capstone_cv_part`.

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

<details>
  <summary>EE584 Machine Vision</summary>
  
  ## EE584 Machine Vision Project: Implementing StereoSnakes

  ![comparison](https://user-images.githubusercontent.com/97564250/236255629-347c0ab9-0931-4cb5-bd23-29679576abd1.jpg)
  
  This is an implementation of ICCV 2015 [paper](/metu_ee584_machine_vision_stereo_snakes/doc/Ju_StereoSnakes_Contour_Based_ICCV_2015_paper.pdf) completely coded by our group of two. The work consists of stereo-aided segmentation and Matlab GUI. The method takes input of a single stereo image, that is foreground-segmented by an arbitrary algorithm. Then, energy functions (depending on the parameters) strives to fit best segmentation to the second stereo image. The advantage of this method is that it has potential to improve input segmentation and to segment occluded objects in the first image.
  
  > Relevant content is [here](/metu_ee584_machine_vision_stereo_snakes). The code is not compiled, should be run in MATLAB 2016a or later.

  <p float="left">
    <img src="https://user-images.githubusercontent.com/97564250/236255639-e9ce31c2-7c02-4014-b7b9-0134496848e0.JPG" width="75%">
  </p>
  
  _Figure: StereoSnakes Matlab GUI (please follow steps in the user manual section our [report](/metu_ee584_machine_vision_stereo_snakes/doc/EE584_final_report_bora_volkan.pdf) to familiarize with the parameters and interface)_

</details>

<details>
  <summary>EE634 Digital Image Processing</summary>
  
  ## EE634 Digital Image Processing Project: Watershed Segmentation

  <p float="left">
    <img title="beach_onlyridgelines" src="https://user-images.githubusercontent.com/97564250/236262880-872e1d30-edfa-4d33-8c24-ddd50f7768cd.JPG" width="24%">
    <img title="beach_segments" src="https://user-images.githubusercontent.com/97564250/236262923-66ce8ab2-9a7d-46fa-9263-1f56743daa4a.JPG" width="24%">
    <img title="hats_onlyridgelines" src="https://user-images.githubusercontent.com/97564250/236262940-4360fa77-bb62-412c-8081-328d94079a85.JPG" width="24%">
    <img title="hats_segments" src="https://user-images.githubusercontent.com/97564250/236262945-4332ba9f-359c-4df4-a237-5eecee72f329.JPG" width="24%">
    <img title="candies_onlyridgelines" src="https://user-images.githubusercontent.com/97564250/236262931-6f02ba05-7725-4080-8519-551de8290e55.JPG" width="24%">
    <img title="candies_segments" src="https://user-images.githubusercontent.com/97564250/236262935-2b60ba3c-327b-4d44-9ca7-04e2e49cc81d.JPG" width="24%">
    <img title="peppers_onlyridgelines" src="https://user-images.githubusercontent.com/97564250/236262962-5c668097-3bd0-4f91-aeb9-86dea915766e.JPG" width="24%">
    <img title="peppers_segments" src="https://user-images.githubusercontent.com/97564250/236262915-9e278be9-d6f5-416f-a5e3-cd77033c5d2c.JPG" width="24%">
    <img title="peppers_onlyridgelines" src="https://user-images.githubusercontent.com/97564250/236262952-ce7bc4bd-c4e1-4f07-bfd9-065e069b1707.JPG" width="48%">
    <img title="parrots_segments" src="https://user-images.githubusercontent.com/97564250/236262960-9a5625ac-c309-4ee4-9d5d-ac0cc5fcc377.JPG" width="48%">
  </p>

  _Figure: Watershed ridgelines on original images and segmentation results_
  
  This script is a part of a project to test and compare distinct segmetation algorithms on richly colored images. My objective was to implement watershed algorithm on the given images. I tackled with the oversegmentation problem which is typical to this method by filtering and merging similar blobs of segmentations.
  
  > Relevant content is [here](/metu_ee634_digital_image_processing_watershed_segmentation). The code is not compiled, should be run in MATLAB 2016a or later.
</details>

<details>
  <summary>EE636 Digital Video Processing</summary>
  
  ## EE636 Digital Video Processing Project: Implementing Tracking in Crowds
  
  https://user-images.githubusercontent.com/97564250/236273516-d16a81c5-aa7c-4374-9ecf-3304126f0898.mp4
  
  This is an implementation of ECCV 2008 [paper](/metu_ee636_digital_video_processing_tracking_in_crowds/doc/TrackingInCrowds_ECC2008(MAIN%20PAPER).pdf) completely coded by me. The method, first, analyzes several frames of the video to understand the general movement flow of the crowd (offline). Then, the object in a user-selected window is tracked by combining offline analysis and online tracking by photometric features. Please see the [documents](/metu_ee636_digital_video_processing_tracking_in_crowds/doc) to familiarize with parameters and for the detailed explanation of the algorithm. 
  
  >**Note** Offline part is encapsulated in the `initialize.m` which analyzes video to get SFF and BFF information. Finally, run `real_time.m` to select an object to track by dragging the marker on the desired location and, then, by double-clicking it. Both scripts have several parameters adjusted to default values.
  
  > Relevant content is [here](/metu_ee636_digital_video_processing_tracking_in_crowds). The code is not compiled, should be run in MATLAB 2016a or later.
</details>

<details>
  <summary>CENG561 Artificial Intelligence</summary>
  
  ## CENG561 Artificial Intelligence Project: Map Spanning (Cleanbot)
  
  >**Warning** This project has its own repository, please visit [here](https://github.com/volkbay/cleanbot).

</details>

<details>
  <summary>CENG786 Robot Motion Planning & Control</summary>
  
  ## CENG786 Robot Motion Planning & Control Project: Implementing a Multi-robot Path Planner
  
  <p>
    <video src="https://user-images.githubusercontent.com/97564250/236289566-69da7d60-be8c-4243-a958-bbb30d3f0745.mp4" type="video/mp4" width="10%">
    <p float="left">
       <img title="path1" src="https://user-images.githubusercontent.com/97564250/236290029-95a57601-9748-408b-977c-5c1849816f13.png" width="32%">
       <img title="path2" src="https://user-images.githubusercontent.com/97564250/236290033-1fd7ada6-967d-4929-81e8-c8a23bed62b2.png" width="32%">
       <img title="path3" src="https://user-images.githubusercontent.com/97564250/236290037-8802620c-eb24-41b5-ab84-1fc20fedf425.png" width="32%">
    </p>
  </p>

  _Figure: Efficient paths of each robot between respective starting and target locations_
  
  This is an implementation of IJRR 2016 [paper](/metu_ceng786_robot_motion_planning/doc/Solovey(2016)_Discrete%20RRT%20for%20exploration%20of%20implicit%20roadmaps%20in%20multi%20robot%20motion%20planning.pdf) completely coded by me. Due to the fact that this is a term project, I partially realized the 2D map experiments of the work (there are also 3D experiments). Basically, this is a composed method exploring implicit paths in a multi-robot scene, each having a start and destination point. The main idea is discretizing the popular RRT algorithm to get most cost efficient motion planning.
  
The robots are holonomic and circular with 2DOF. Obstacles are convex or concave polyhedral 2D objects in a 10x10 meters map. The map obstacle geometries are embedded in the `init_arena` script. Main function `main_project_ceng786` may be called with two parameters namely _case_number_ and _number_of_vertices_. First one determines which the type of the arena, start-target locations and the number of robots, while the latter is for PRM calculation of each agent.

> Relevant content is [here](/metu_ceng786_robot_motion_planning). The code is not compiled, should be run in MATLAB 2016a or later.

</details>

<details>
  <summary>EEE Graduate Thesis Project</summary>
  
  ## Electrical-Electronics Eng. MSc Thesis Project: Automated Image Processing for Scratch Detection on Specular Surfaces
  
  >**Warning** This project has its own repository, please visit [here](https://github.com/volkbay/AIPSDSS).

</details>
