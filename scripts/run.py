#!/usr/bin/env python
"""
@author: Tamas Borbas
"""
import subprocess
from subprocess import TimeoutExpired
from subprocess import CalledProcessError


"""
TIMEOUT is in seconds
"""
CONST_TIMEOUT=650


"""
Valid values for TRANSFORMATOR_TYPES:
    "BATCH_SIMPLE",
    "BATCH_OPTIMIZED",
    "BATCH_INCQUERY",
    "BATCH_VIATRA",
    "INCR_QUERY_RESULT_TRACEABILITY",
    "INCR_EXPLICIT_TRACEABILITY",
    "INCR_AGGREGATED",
    "INCR_VIATRA",
"""
TRANSFORMATOR_TYPES=["BATCH_SIMPLE"]


"""
SCALES are integers
"""
SCALES=[3,4]


"""
Valid values for GENERATOR_TYPES:
    "DISTRIBUTED",
    "JDT_BASED"
"""
GENERATOR_TYPES=["DISTRIBUTED"]


def flatten(lst):
    return sum(([x] if not isinstance(x, list) else flatten(x) for x in lst), [])


def starteclipses():
    for genType in GENERATOR_TYPES:
        for scale in SCALES:
            for trafoType in TRANSFORMATOR_TYPES:
                try:
                    subprocess.call(flatten(["eclipse\eclipse.exe", trafoType, str(scale), genType]), timeout=CONST_TIMEOUT)
                except TimeoutExpired:
                    print("Timed out after ", CONST_TIMEOUT, "s, continuing with the next query.")
                    break
                except CalledProcessError as e:
                    print("Program exited with error")
                    break


if __name__ == "__main__":
    starteclipses()
