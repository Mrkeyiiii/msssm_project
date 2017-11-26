close all ; clear ; clc
cd('..')

s = rng('shuffle','twister');

rng(s)
simulate('config_demo_E-0.2')

rng(s)
simulate('config_demo_E-0.8')