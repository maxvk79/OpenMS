# --------------------------------------------------------------------------
#                   OpenMS -- Open-Source Mass Spectrometry
# --------------------------------------------------------------------------
# Copyright The OpenMS Team -- Eberhard Karls University Tuebingen,
# ETH Zurich, and Freie Universitaet Berlin 2002-2022.
#
# This software is released under a three-clause BSD license:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of any author or any participating institution
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
# For a full list of authors, refer to the file AUTHORS.
# --------------------------------------------------------------------------
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL ANY OF THE AUTHORS OR THE CONTRIBUTING
# INSTITUTIONS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# --------------------------------------------------------------------------
# $Maintainer: Julianus Pfeuffer $
# $Authors: Julianus Pfeuffer $
# --------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

# include helper functions 
include ( ${SCRIPT_DIR}common.cmake )

set(required_variables "TOOLNAME;CTD_FILE")
check_variables(required_variables)

set(filename ${CTD_FILE})

file(READ "${filename}" contents)
string(REPLACE "[" "_OPENBRACKET_" contents "${contents}")
string(REPLACE "]" "_CLOSEBRACKET_" contents "${contents}")
string(REPLACE ";" "\\\;" contents "${contents}")
string(REGEX REPLACE "\n" ";" contents "${contents}")

set(APPEND_TO_FILE FALSE)
foreach(line ${contents})
  string(REGEX REPLACE "(.*tool.*)name=\"([^ ]*)\"(.*)" "\\1executableName=\"\\2\" name=\"${TOOLNAME}\"\\3" line ${line})
  
  string(REPLACE "_OPENBRACKET_" "[" line "${line}")
  string(REPLACE "_CLOSEBRACKET_" "]" line "${line}")

  if(APPEND_TO_FILE)
    file(APPEND "${filename}" "${line}\n")
  else() 
    # write the first line
    file(WRITE "${filename}" "${line}\n")
    # append the rest
    set(APPEND_TO_FILE TRUE)
  endif()
endforeach()