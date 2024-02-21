## M2HG-CD
SAR Image Change Detection via Heterogeneous Graph with Multi-order and Multi-level Connections.

## Introduction
In this study, a novel SAR image change detection approach based on heterogeneous graph with multi-level and multi-order connections (M2HG) is proposed. The main contributions are as follows.
(1) First of all, a heterogeneous graph is rigorously designed based on multi-level connections rather than single connection, in order to effectively capture the complex neighborhood information among similar pixels in the whole image. With respect to the graph structure, three types of edges representing multi-level connections are constructed by traversing the local, non-local and global neighbors. This allows for a wider receptive field for the heterogeneous graph, and thus the description and discrimination of ground objects could be enhanced.
(2) From the constructed heterogeneous graph, a composite random walk matrix (CRWM) is proposed to quantify the similarity of multi-level connections. A heterogeneous graph shift system, represented by the combination of the multi-order CRWM, is then designed to aggregate the attributes of neighboring vertices along the multi-order and multi-level connections. The difference image with good separability can be created by comparing the bitemporal output signals through the heterogeneous graph shift systems. The final change map is obtained using binary classification algorithm.

## Citation
If you use this code for your research, please cite our paper. Thank you!

@ARTICLE{**, 
  author={Jun Wang, Fei Zeng, Sanku Niu, Jun Zheng, Xiaoliang Jiang},  
  journal={IEEE Journal of Selected Topics in Applied Earth Observations and Remote Sensing},   
  title={SAR Image Change Detection via Heterogeneous Graph with Multi-order and Multi-level Connections},   
  year={2024}.}  
  
## Running
Run the M2HG-CD demo files (tested in Matlab 2023b)! 
If you have any queries, please contact me (36110@qzc.edu.cn).
