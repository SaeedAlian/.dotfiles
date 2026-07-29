#!/bin/sh

in_container() { [ -f /run/.containerenv ] || [ -f /.dockerenv ]; }
