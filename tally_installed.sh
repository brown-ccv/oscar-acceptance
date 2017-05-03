#!/bin/bash

# Aim: check off installed against centos6

ls /gpfs/runtime/modulefiles > rh7_mods

grep -Fxv -f rh7_mods centos6_mods
