# MeanShapeM

## Introduction
In biomedical image analysis, many tasks rely on an underlying image segmentation step which affects often greatly further downstream analysis. Therefore, both improving and knowing the accuracy of the segmentation is necessary to be able to assess the analysis accuracy itself. The former can be established by segmenting the same images by multiple expert annotators and fusing the resulting labels or masks to a single segmentation, while the accuracy can then be measured by looking at the agreement between the annotators. Popular techniques such as STAPLE consider each pixel separately, thereby allowing very complex but also often unrealistic complex resulting estimations for best fused labels. Here we introduce a contour-averaging technique which obtains a ground truth estimation as a smooth curve from multiple region annotations and retains their local features. The metric defined by the approach can be both used to give outliers less weight in the average curve as well as to estimate the accuracy of the final segmentation. By virtue of the method, it is also applicable for obtaining smooth transitions between two different segmentations. The proposed algorithm is based on a contour energy minimization by a variational method.

We have implemented it both as a ImageJ plugin (MeanShapeJ), a C++ version, Python script (MeanShapePy), and a MATLAB script (this repo). This version is specifically made to enable easy testing and probing of the algorithm.

## Getting started

MeanShapeM is is a MATLAB script, at this moment there is no executable provided.
The main script files are:
  - meanshape_script_vx.m
  - meanshape_batch_vx.m
  - meanshape_gui_vx.m
  
where vx stands for the version number, e.g.: v1, v2, v3, ...

An example dataset with downscaled brain slices and brain region annotations can be found in the dataset subfolder of the [still have to upload the example set]

## Authors

Jozsef Molnar, Michael Barbier, Winnok De Vos, and Peter Horvath
