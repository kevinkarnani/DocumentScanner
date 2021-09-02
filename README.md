# DocumentScanner

## Introduction

This is a refactored version of the document scanner I wrote for my Computational Photography class. It uses an edged image, computes its Hough Transform, finds the best 4 lines, computes the corners, and rectifies the image by applying a Homography Transformation.

## Getting Started

### Prerequisites

The following dependencies are required:<br/>

* Computer Vision Toolbox

### Running The Code

The high level files are `main.m` and `scanner.m`. The main script allows for picking the image you wish to "scan", and scanner calls all the lower level functions to compute the rectified image.

## Contributions

Kevin Karnani

Adin Solomon