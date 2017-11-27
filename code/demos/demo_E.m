close all ; clear ; clc
cd('..')

s = rng('shuffle','twister');

rng(s)
simulate('data/config_demo_E-0.2.conf');

rng(s)
simulate('data/config_demo_E-0.8.conf');