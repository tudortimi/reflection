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


class rf_class extends rf_base;

  extern function string get_name();
  extern function bit is_abstract();

  // XXX Not supported in IUS
  //extern function array_of_rf_attribute get_attributes();

  extern function array_of_rf_variable get_variables();
  extern function rf_variable get_variable_by_name(string name);

  extern function array_of_rf_method get_methods();
  extern function rf_method get_method_by_name(string name);

  extern function array_of_rf_task get_tasks();
  extern function rf_task get_task_by_name(string name);

  extern function array_of_rf_function get_functions();
  extern function rf_function get_function_by_name(string name);

  extern function rf_class get_base_class();
  //extern function array_of_rf_class get_subclasses();

  extern virtual function bit equals(rf_base other);
  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected const vpiHandle classDefn;

  local const variable_introspection var_intro;

  function new(vpiHandle classDefn);
    this.classDefn = classDefn;

    var_intro = new(classDefn);
  endfunction


  // TODO Only works for non-parameterized classes
  /* package */function vpiHandle get_typespec();
    vpiHandle typespec_it = vpi_iterate(vpiClassTypespec, classDefn);
    return vpi_scan(typespec_it);
  endfunction


  local function rf_method create_method(vpiHandle method);
    case (vpi_get(vpiType, method))
      vpiTask : begin
        rf_task t = new(method);
        return t;
      end

      vpiFunction : begin
        rf_function f = new(method);
        return f;
      end

      default : $fatal(0, "Internal error");
    endcase
  endfunction
endclass



function string rf_class::get_name();
  return vpi_get_str(vpiName, classDefn);
endfunction


function bit rf_class::is_abstract();
  return vpi_get(vpiVirtual, classDefn);
endfunction


//function array_of_rf_attribute rf_class::get_attributes();
//  rf_attribute attrs[$];
//  vpiHandle variables_it = vpi_iterate(vpiAttribute, classDefn);
//endfunction


function array_of_rf_variable rf_class::get_variables();
  return var_intro.get_all();
endfunction


function rf_variable rf_class::get_variable_by_name(string name);
  return var_intro.get_by_name(name);
endfunction


function array_of_rf_method rf_class::get_methods();
  rf_method methods[$];
  vpiHandle methods_it = vpi_iterate(vpiMethods, classDefn);
  if (methods_it != null)
    while (1) begin
      rf_method m;
      vpiHandle method = vpi_scan(methods_it);
      if (method == null)
        break;
      m = create_method(method);
      methods.push_back(m);
    end
  return methods;
endfunction


function rf_method rf_class::get_method_by_name(string name);
  vpiHandle methods_it = vpi_iterate(vpiMethods, classDefn);
  while (1) begin
    vpiHandle method = vpi_scan(methods_it);
    if (method == null)
      break;
    if (vpi_get_str(vpiName, method) == name) begin
      rf_method m = create_method(method);
      return m;
    end
  end
endfunction


function array_of_rf_task rf_class::get_tasks();
  rf_method methods[] = get_methods();
  rf_task tasks[$];
  foreach (methods[i])
    if (methods[i].get_kind() == TASK) begin
      rf_task t;
      if (!$cast(t, methods[i]))
        $fatal(0, "Internal error");
      tasks.push_back(t);
    end
  return tasks;
endfunction


function rf_task rf_class::get_task_by_name(string name);
  rf_method m = get_method_by_name(name);
  rf_task t;
  if (m != null && m.get_kind() == TASK) begin
    if (!$cast(t, m))
      $fatal(0, "Internal error");
    return t;
  end
endfunction


function array_of_rf_function rf_class::get_functions();
  rf_method methods[] = get_methods();
  rf_function functions[$];
  foreach (methods[i])
    if (methods[i].get_kind() == FUNCTION) begin
      rf_function f;
      if (!$cast(f, methods[i]))
        $fatal(0, "Internal error");
      functions.push_back(f);
    end
  return functions;
endfunction


function rf_function rf_class::get_function_by_name(string name);
  rf_method m = get_method_by_name(name);
  rf_function f;
  if (m != null && m.get_kind() == FUNCTION) begin
    if (!$cast(f, m))
      $fatal(0, "Internal error");
    return f;
  end
endfunction


function rf_class rf_class::get_base_class();
  vpiHandle e = vpi_handle(vpiExtends, classDefn);
  rf_class bc;
  if (e == null)
    return null;
  bc = new(vpi_handle(vpiClassDefn, vpi_handle(vpiClassTypespec, e)));
  return bc;
endfunction


//function array_of_rf_class rf_class::get_subclasses();
//  rf_class subclasses[$];
//  vpiHandle dc_iter = vpi_iterate(vpiDerivedClasses, classDefn);
//  if (dc_iter == null)
//    return '{};
//endfunction


function bit rf_class::equals(rf_base other);
  rf_class other_as_class;
  if (!$cast(other_as_class, other))
    return 0;
  return classDefn == other_as_class.classDefn;
endfunction


function void rf_class::print(int unsigned indent = 0);
  rf_variable vars[] = get_variables();
  rf_method methods[] = get_methods();
  $display({indent{" "}}, "Class '%s'", get_name());
  foreach (vars[i])
    vars[i].print(indent + 2);
  foreach (methods[i])
    methods[i].print(indent + 2);
endfunction
