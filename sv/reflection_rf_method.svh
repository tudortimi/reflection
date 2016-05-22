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


virtual class rf_method;
  extern function string get_name();
  extern function method_kind_e get_kind();

  extern function array_of_rf_io_declaration get_io_declarations();
  extern function rf_io_declaration get_io_declaration_by_name(string name);

  extern function void print(int unsigned indent = 0);


  //----------------------------------------------------------------------------
  // Internal
  //----------------------------------------------------------------------------

  protected vpiHandle method;

  function new(vpiHandle method);
    this.method = method;
  endfunction
endclass



function string rf_method::get_name();
  return vpi_get_str(vpiName, method);
endfunction


function method_kind_e rf_method::get_kind();
  case (vpi_get(vpiType, method))
    vpiTask : return TASK;
    vpiFunction : return FUNCTION;
    default : $fatal(0, "Internal error");
  endcase
endfunction


function array_of_rf_io_declaration rf_method::get_io_declarations();
  rf_io_declaration io_decls[$];
  vpiHandle io_declarations_it = vpi_iterate(vpiIODecl, method);
  if (io_declarations_it != null)
    while (1) begin
      rf_io_declaration io;
      vpiHandle io_declaration = vpi_scan(io_declarations_it);
      if (io_declaration == null)
        break;
      io = new(io_declaration);
      io_decls.push_back(io);
    end
  return io_decls;
endfunction


function rf_io_declaration rf_method::get_io_declaration_by_name(string name);
  vpiHandle io_declarations_it = vpi_iterate(vpiIODecl, method);
  if (io_declarations_it != null)
    while (1) begin
      vpiHandle io_declaration = vpi_scan(io_declarations_it);
      if (io_declaration == null)
        break;
      if (vpi_get_str(vpiName, io_declaration) == name) begin
        rf_io_declaration io = new(io_declaration);
        return io;
      end
    end
endfunction


function void rf_method::print(int unsigned indent = 0);
  string kind = get_kind() == FUNCTION ? "Function" : "Task";
  rf_io_declaration io_decls[] = get_io_declarations();
  $display({indent{" "}}, "%s '%s'", kind, get_name());
  foreach (io_decls[i])
    io_decls[i].print(indent + 2);
endfunction
