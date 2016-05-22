// Copyright 2016 Tudor Timisescu (verificationgentleman.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


class some_class;
  int some_variable;
  rand int some_rand_variable;
  randc int some_randc_variable;

  int some_int_var;

  task some_task();
  endtask

  function void some_function();
  endfunction

  function void some_function_with_args(input int input_arg,
    output int output_arg, inout int inout_arg);
  endfunction

  function void some_void_function();
  endfunction

  function int some_int_function();
  endfunction
endclass
