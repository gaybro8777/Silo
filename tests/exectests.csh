#!/bin/csh -f
########################################################################
# Copyright (c) 1994 - 2010, Lawrence Livermore National Security, LLC.
# LLNL-CODE-425250.
# All rights reserved.
# 
# This file is part of Silo. For details, see silo.llnl.gov.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the disclaimer below.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the disclaimer (as noted
#      below) in the documentation and/or other materials provided with
#      the distribution.
#    * Neither the name of the LLNS/LLNL nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
# 
# THIS SOFTWARE  IS PROVIDED BY  THE COPYRIGHT HOLDERS  AND CONTRIBUTORS
# "AS  IS" AND  ANY EXPRESS  OR IMPLIED  WARRANTIES, INCLUDING,  BUT NOT
# LIMITED TO, THE IMPLIED  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A  PARTICULAR  PURPOSE ARE  DISCLAIMED.  IN  NO  EVENT SHALL  LAWRENCE
# LIVERMORE  NATIONAL SECURITY, LLC,  THE U.S.  DEPARTMENT OF  ENERGY OR
# CONTRIBUTORS BE LIABLE FOR  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR  CONSEQUENTIAL DAMAGES  (INCLUDING, BUT NOT  LIMITED TO,
# PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS  OF USE,  DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER  IN CONTRACT, STRICT LIABILITY,  OR TORT (INCLUDING
# NEGLIGENCE OR  OTHERWISE) ARISING IN  ANY WAY OUT  OF THE USE  OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# This work was produced at Lawrence Livermore National Laboratory under
# Contract No.  DE-AC52-07NA27344 with the DOE.
# 
# Neither the  United States Government nor  Lawrence Livermore National
# Security, LLC nor any of  their employees, makes any warranty, express
# or  implied,  or  assumes  any  liability or  responsibility  for  the
# accuracy, completeness,  or usefulness of  any information, apparatus,
# product, or  process disclosed, or  represents that its use  would not
# infringe privately-owned rights.
# 
# Any reference herein to  any specific commercial products, process, or
# services by trade name,  trademark, manufacturer or otherwise does not
# necessarily  constitute or imply  its endorsement,  recommendation, or
# favoring  by  the  United  States  Government  or  Lawrence  Livermore
# National Security,  LLC. The views  and opinions of  authors expressed
# herein do not necessarily state  or reflect those of the United States
# Government or Lawrence Livermore National Security, LLC, and shall not
########################################################################

echo ""
echo "-------------------------- Conducting Silo Test ----------------------------"

#----------------------------------------------------------
#                     EXECTESTS.CSH
#
# FUNCTION:
#
#    Execute and validate the results of Silo Library test
#    cases contained in this directory.
#
#    This script program assumes the existence of a
#    `Makefile' that contains a set of known targets.
#
# COMMAND LINE:
#
#    exectests.csh
#
# RETURN VALUE:
#
#    0 --> No errors.
#          All test cases executed and validated.
#
#    1 --> At least one test case could not be validated.
#
#----------------------------------------------------------

#----------------------------------------------------------------
# Determine whether or not the Silo packages have been installed.
#----------------------------------------------------------------
#
# We should do better than "../../include/silo.h".  Maybe we should generate
# this file at configure time. (Sean Ahern - Tue Jul 30 16:38:33 PDT 1996)
if (!(-e ../../include/silo.h)) then
  exit (0)
endif

#-----------------------------
# Prepare directory for tests.
#-----------------------------

#We shouldn't need to do this. (Sean Ahern - Tue Jul 30 16:38:05 PDT 1996)
#cp ../../include/silo.inc .

set Tests = (testall array dir point quad)
set Tests = ($Tests simple ucd ucdsamp3 arrayf77 matf77)
set Tests = ($Tests pointf77 quadf77 ucdf77 testallf77)
set F77Tests = (FALSE FALSE FALSE FALSE FALSE)
set F77Tests = ($F77Tests FALSE FALSE FALSE TRUE TRUE)
set F77Tests = ($F77Tests TRUE TRUE TRUE TRUE)

#-----------------------------------------------------
# Execute the test cases.
#
# The procedure for executing a test case is---
#
#    1. Compile the test case source.
#    2. Link using the development libraries.
#    3. Run the executable.
#
# Failures on Fortran test cases are not treated as
# fatal because of a make problem concerning F77 and
# GCC.
#-----------------------------------------------------
echo " "
echo "Execution of Silo Tests in /test"
echo "`date`"

echo " "
echo "Execute silo file test generators..."

@ i = 1
foreach test ($Tests)
   echo "Executing test case $test..."

#-----------------------------------------------
#     Make and execute for development libs.
#-----------------------------------------------
   make ${test}
   ./${test}
   if ($status != 0 && $F77Tests[$i] == FALSE) then
      echo "Error executing test case $test"
      exit (1)
   endif

   @ i++
end

echo "---------------------------- Silo Test Passed ------------------------------"

exit (0)

end
