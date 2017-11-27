close all ; clear ; clc
cd('..')

s = rng('shuffle','twister');
rng(s)
simulate('data/config_demo_V.conf');