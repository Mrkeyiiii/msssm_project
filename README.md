# MATLAB Fall 2017 – Research Plan

> * Group Name: LQS
> * Group participants names: Lefkopoulos Vasileios, Qi Shuaixin, Signer Matteo
> * Project Title: Decision-making in the social force model for an evacuation process


## General Introduction

Modelling and simulating the evacuation procedure in an evacuation procedure scenario is a well-studied problem. Through this, it is possible to optimize various parameters of such a real-life scenario in order to maximize the efficiency of an evacuation and minimize the evacuation time and potential human casualties.


## The Model

A social force model is used to capture the crowd dynamics, as proposed in [1]. Further work and modifications on the social force model was done in [2], including the addition of a decision-making capability in the agents of the model. This model was then subsequently adapted to a real-life scenario, with some modifications, in [3]. The model that was used in this project was based on the model of [3], although modifications and alterations where made wherever necessary (some of which where inspired from elements of [1] and [2] that weren’t included in [3]). The code of this project was based on the framework and code of a previous MSSSM group [4].

The independent variables of our model will be:
* The panic level of the agents
* The excitement factor of the agents

By varying these parameters we would like to simulate the evacuation procedure and dynamics of the crowd.


## Fundamental Questions

1. How does the desired velocity affect the behaviour of the agents during the evacuation?
2. How does the desired velocity affect the evacuation time?
3. How does the panic level affect the behaviour of the agents during the evacuation?
4. How does the panic level affect the evacuation time?
5. How does the excitement factor affect the behaviour of the agents during the evacuation?


## Expected Results

1. A higher desired velocity will probably cause the agents to move faster.
2. A higher desired velocity will probably lead to a smaller evacuation time.
3. A higher panic level will probably cause the agents to behave less rationally and more impulsively.
4. A high panic level should lead to a higher evacuation time.
5. A higher excitement factor will probably cause the agents to take less informed decisions.


## References 

[1] Helbing, Farkas & Vicsek (2000): Simulating dynamical features of escape panic

[2] Zainuddin & Shuaib (2010): Modification of the Decision-Making Capability in the Social Force Model for the Evacuation Process

[3] Wang et al. (2016): Pedestrians’ behavior in emergency evacuation: Modeling and simulation

[4] Hardmeier, Jenal, Kueng, Thaler (2012): [Modelling Situations of Evacuation in a Multi-level Building](https://github.com/msssm/MultiLevelEvacuation_with_custom_C_code)
