// Copyright 2016-2018 Tudor Timisescu (verificationgentleman.com)
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


typedef enum { NOT_RAND, RAND, RANDC } rand_type_e;
typedef enum { INPUT, OUTPUT, INOUT } io_direction_e;
typedef enum { TASK, FUNCTION } method_kind_e;

typedef class rf_attribute;
typedef rf_attribute array_of_rf_attribute[];

typedef class rf_class;
typedef rf_class array_of_rf_class[];

typedef class rf_variable;
typedef rf_variable array_of_rf_variable[];

typedef class rf_io_declaration;
typedef rf_io_declaration array_of_rf_io_declaration[];

typedef class rf_method;
typedef rf_method array_of_rf_method[];

typedef class rf_task;
typedef rf_task array_of_rf_task[];

typedef class rf_function;
typedef rf_function array_of_rf_function[];
